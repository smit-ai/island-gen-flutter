import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/models/layer.dart';
import 'package:vector_math/vector_math.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:island_gen_flutter/features/heightmap_generator/extentions.dart';

class HeightmapGenerator {
  static Future<ui.Image> noise(
    int width,
    int height, {
    double scale = 1.0,
    int octaves = 4,
    double persistence = 0.5,
    double frequency = 1.0,
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
    final uniformData = Float32List(5);
    uniformData[0] = scale;
    uniformData[1] = octaves.toDouble();
    uniformData[2] = persistence;
    uniformData[3] = seed.toDouble();
    uniformData[4] = frequency;

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

  static Future<ui.Image> blendLayerStack(List<Layer> layers, int width, int height) async {
    if (layers.isEmpty) {
      throw Exception('Layer stack is empty');
    }

    final validLayers = layers.where((layer) => layer.cachedData != null).toList();

    // If only one layer, return it directly
    if (validLayers.length == 1) {
      return validLayers.first.cachedData!;
    }

    // Create vertex buffer for quad
    final vertices = Float32List.fromList([
      // pos(xy), uv
      -1.0, -1.0, 0.0, 1.0, // Bottom left
      1.0, -1.0, 1.0, 1.0, // Bottom right
      -1.0, 1.0, 0.0, 0.0, // Top left
      1.0, 1.0, 1.0, 0.0, // Top right
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

    // Get shaders for blending
    final vert = shaderLibrary['NoiseVertex']!;
    final frag = shaderLibrary['BlendFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    // Start with the bottom layer
    var currentTexture = await TextureExtensions.fromImage(
      validLayers.first.cachedData!,
      gpu.PixelFormat.r8g8b8a8UNormInt,
    );

    // Process each layer from bottom to top
    for (int i = 1; i < validLayers.length; i++) {
      final nextLayer = validLayers[i];
      final nextTexture = await TextureExtensions.fromImage(
        nextLayer.cachedData!,
        gpu.PixelFormat.r8g8b8a8UNormInt,
      );

      // Create blend mode and opacity uniform buffer
      final uniformData = Float32List(2);
      uniformData[0] = nextLayer.blendMode.index.toDouble();
      uniformData[1] = nextLayer.influence;

      final uniformBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
        ByteData.sublistView(uniformData),
      )!;

      // Set up render target for the blend operation
      final renderTarget = gpu.RenderTarget.singleColor(
        gpu.ColorAttachment(
          texture: gpu.gpuContext.createTexture(
            gpu.StorageMode.devicePrivate,
            width,
            height,
            format: gpu.PixelFormat.r8g8b8a8UNormInt,
            enableShaderReadUsage: true,
          )!,
          clearValue: Vector4(0.0, 0.0, 0.0, 1.0),
        ),
      );

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

      renderPass.bindTexture(
        pipeline.fragmentShader.getUniformSlot('baseTexture'),
        currentTexture,
      );
      renderPass.bindTexture(
        pipeline.fragmentShader.getUniformSlot('blendTexture'),
        nextTexture,
      );
      renderPass.bindUniform(
        pipeline.fragmentShader.getUniformSlot('BlendParams'),
        gpu.BufferView(
          uniformBuffer,
          offsetInBytes: 0,
          lengthInBytes: uniformBuffer.sizeInBytes,
        ),
      );

      // Draw quad to perform blend
      renderPass.draw();
      commandBuffer.submit();

      // Update current texture for next iteration
      currentTexture = renderTarget.colorAttachments.first.texture;
    }

    // Get final image and clean up
    final result = currentTexture.asImage();
    return result;
  }
}
