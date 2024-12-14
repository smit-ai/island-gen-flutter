import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:vector_math/vector_math.dart';
import 'package:island_gen_flutter/shaders.dart';

class HeightmapGenerator {
  static Future<ui.Image> noise(
    int width,
    int height, {
    double scale = 1.0,
    int octaves = 4,
    double persistence = 0.5,
    int seed = 0,
  }) async {
    // Create vertex buffer for quad
    final vertices = Float32List.fromList([
      // pos(xy), uv
      -1.0, -1.0, 0.0, 0.0, // Bottom left
      1.0, -1.0, 1.0, 0.0, // Bottom right
      -1.0, 1.0, 0.0, 1.0, // Top left
      1.0, 1.0, 1.0, 1.0, // Top right
    ]);

    final indices = Uint16List.fromList([
      0, 1, 2, // First triangle
      2, 1, 3, // Second triangle
    ]);

    final vertexBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(vertices),
    )!;

    final indexBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(indices),
    )!;

    // Create uniform buffer for noise parameters
    final uniformData = Float32List(4);
    uniformData[0] = scale;
    uniformData[1] = octaves.toDouble();
    uniformData[2] = persistence;
    uniformData[3] = seed.toDouble();

    final uniformBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(uniformData),
    )!;

    // Create texture to render into
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      width,
      height,
    )!;

    // Set up render target
    final renderTarget = gpu.RenderTarget.singleColor(
      gpu.ColorAttachment(
        texture: texture,
        clearValue: Vector4(0.0, 0.0, 0.0, 1.0),
      ),
    );

    // Get shaders and create pipeline
    final vert = shaderLibrary['NoiseVertex']!;
    final frag = shaderLibrary['NoiseFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    // Set up command buffer and render pass
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);

    // Bind pipeline and resources
    renderPass.bindPipeline(pipeline);
    renderPass.bindVertexBuffer(
      gpu.BufferView(
        vertexBuffer,
        offsetInBytes: 0,
        lengthInBytes: vertexBuffer.sizeInBytes,
      ),
      4, // 4 vertices
    );

    renderPass.bindIndexBuffer(
      gpu.BufferView(
        indexBuffer,
        offsetInBytes: 0,
        lengthInBytes: indexBuffer.sizeInBytes,
      ),
      gpu.IndexType.int16,
      6, // 6 indices
    );

    renderPass.bindUniform(
      frag.getUniformSlot('NoiseParams'),
      gpu.BufferView(
        uniformBuffer,
        offsetInBytes: 0,
        lengthInBytes: uniformBuffer.sizeInBytes,
      ),
    );

    // Draw quad
    renderPass.draw();
    commandBuffer.submit();

    // Convert to Flutter Image
    return texture.asImage();
  }
}
