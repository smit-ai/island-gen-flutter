import 'dart:typed_data';

import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/heightmap_generator/heightmap_generator.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vector_math/vector_math.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/heightmap_provider/heightmap_provider.g.dart';

@Riverpod(keepAlive: true)
class HeightmapData extends _$HeightmapData {
  @override
  gpu.Texture build() {
    ref.listen(globalStateProvider, (previous, next) {
      if (next.activeLayerStack != previous?.activeLayerStack) {
        if (next.activeLayerStack.isNotEmpty) {
          processLayerStack(state);
          ref.notifyListeners();
        }
      }
    });

    ref.listen(globalSettingsProvider, (previous, next) {
      if (previous?.resolution != next.resolution) {
        state = initTexture();
        processLayerStack(state);
        ref.notifyListeners();
      }
    });

    final texture = initTexture();
    processLayerStack(texture);
    return texture;
  }

  gpu.Texture initTexture() {
    final globalSettings = ref.read(globalSettingsProvider);
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      globalSettings.resolution.width.toInt(),
      globalSettings.resolution.height.toInt(),
      format: gpu.PixelFormat.r32g32b32a32Float,
    )!;
    return texture;
  }

  void processLayerStack(gpu.Texture texture) async {
    final layerStack = ref.read(globalStateProvider).activeLayerStack;
    final layers = List<Layer>.from(layerStack);

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

    //TODO fix this hack
    final onlyOneLayer = layers.length == 1;
    if (onlyOneLayer) {
      currentTexture = gpu.gpuContext.createTexture(
        gpu.StorageMode.devicePrivate,
        layers.first.texture.width,
        layers.first.texture.height,
        format: gpu.PixelFormat.r16g16b16a16Float,
      )!;
      HeightmapGenerator.noise(currentTexture, LayerNoiseParams(frequency: 0.01));
    }

    // Process each layer from bottom to top
    for (int i = onlyOneLayer ? 0 : 1; i < layers.length; i++) {
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
  }
}
