import 'dart:typed_data';

import 'package:flutter/material.dart' hide Matrix4;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/camera/camera_state_provider.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:vector_math/vector_math.dart';

class RaymarchedTerrainPainter extends CustomPainter {
  final CameraState cameraState;
  final gpu.Texture heightmapTexture;

  const RaymarchedTerrainPainter({
    required this.cameraState,
    required this.heightmapTexture,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create output textures
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      format: gpu.PixelFormat.r16g16b16a16Float,
    );

    final depthTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      format: gpu.gpuContext.defaultDepthStencilFormat,
    );

    // Set up render target
    final renderTarget = gpu.RenderTarget.singleColor(
      gpu.ColorAttachment(
        texture: texture,
        clearValue: Vector4(0.1, 0.1, 0.1, 1.0),
      ),
      depthStencilAttachment: gpu.DepthStencilAttachment(
        texture: depthTexture,
        depthLoadAction: gpu.LoadAction.clear,
        depthStoreAction: gpu.StoreAction.store,
        depthClearValue: 1.0,
        stencilLoadAction: gpu.LoadAction.clear,
        stencilStoreAction: gpu.StoreAction.dontCare,
        stencilClearValue: 0,
      ),
    );

    // Calculate transformation matrices
    final aspect = size.width / size.height;
    final projection = cameraState.getProjectionMatrix(aspect);
    final view = cameraState.getViewMatrix();
    final model = Matrix4.identity();
    final mvp = projection * view * model;
    final modelView = view * model;
    final cameraPosition = cameraState.getCameraPosition();

    // Create transform uniform buffer
    final transformData = Float32List(16 + 16 + 4);
    transformData.setAll(0, mvp.storage);
    transformData.setAll(16, modelView.storage);
    transformData[32] = cameraPosition.x;
    transformData[33] = cameraPosition.y;
    transformData[34] = cameraPosition.z;
    transformData[35] = 1.0;

    final uniformBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(transformData),
    );

    // Create texture params buffer
    final textureParamsData = Int32List(1);
    textureParamsData[0] = heightmapTexture.width;

    final textureParamsBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(textureParamsData),
    );

    // Create full-screen quad vertices
    final vertices = Float32List.fromList([
      -1.0, -1.0, // Bottom left
      1.0, -1.0, // Bottom right
      -1.0, 1.0, // Top left
      1.0, 1.0, // Top right
    ]);

    final verticesBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(vertices),
    );

    // Set up shaders and pipeline
    final vert = shaderLibrary['RaymarchVertex']!;
    final frag = shaderLibrary['RaymarchFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    // Create and set up render pass
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);
    renderPass.setDepthWriteEnable(true);
    renderPass.setDepthCompareOperation(gpu.CompareFunction.less);

    // Bind pipeline and vertex buffer
    renderPass.bindPipeline(pipeline);
    renderPass.bindVertexBuffer(
      gpu.BufferView(
        verticesBuffer,
        offsetInBytes: 0,
        lengthInBytes: verticesBuffer.sizeInBytes,
      ),
      vertices.length ~/ 2,
    );

    // Bind uniforms
    renderPass.bindUniform(
      vert.getUniformSlot('Transforms'),
      gpu.BufferView(
        uniformBuffer,
        offsetInBytes: 0,
        lengthInBytes: uniformBuffer.sizeInBytes,
      ),
    );

    renderPass.bindTexture(
      frag.getUniformSlot('heightmapTexture'),
      heightmapTexture,
    );

    renderPass.bindUniform(
      frag.getUniformSlot('TextureParams'),
      gpu.BufferView(
        textureParamsBuffer,
        offsetInBytes: 0,
        lengthInBytes: textureParamsBuffer.sizeInBytes,
      ),
    );

    // Draw full-screen quad
    renderPass.setPrimitiveType(gpu.PrimitiveType.triangleStrip);
    renderPass.draw();
    commandBuffer.submit();

    // Draw result to canvas
    final image = texture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant RaymarchedTerrainPainter oldDelegate) {
    return true; // Always repaint when camera changes
  }
}
