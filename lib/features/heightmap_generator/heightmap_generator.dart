import 'dart:typed_data';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/models/layer.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:island_gen_flutter/shaders.dart';

class HeightmapGenerator {
  static String noise(
    gpu.Texture texture,
    LayerNoiseParams noiseParams,
  ) {
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
    final uniformData = Float32List(11);
    uniformData[0] = noiseParams.scale;
    uniformData[1] = noiseParams.octaves.toDouble();
    uniformData[2] = noiseParams.persistence;
    uniformData[3] = noiseParams.seed.toDouble();
    uniformData[4] = noiseParams.frequency;
    uniformData[5] = noiseParams.offsetX;
    uniformData[6] = noiseParams.offsetY;
    uniformData[7] = noiseParams.rotation;
    uniformData[8] = noiseParams.invert ? 1.0 : 0.0;
    uniformData[9] = noiseParams.clampMin;
    uniformData[10] = noiseParams.clampMax;

    final uniformBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(uniformData),
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
    return Uuid().v4();
  }

  static void blendLayerStack({required gpu.Texture texture, required List<Layer> layers}) {
    if (layers.isEmpty) {
      print('Layer stack is empty');
      return;
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
    var currentTexture = layers.first.texture;

    // Process each layer from bottom to top
    for (int i = 1; i < layers.length; i++) {
      final nextLayer = layers[i];
      final nextTexture = nextLayer.texture;

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
          texture: texture,
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

    return;
  }
}
