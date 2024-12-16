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

  // Create transformation matrices and camera data
  ({
    Matrix4 mvp,
    Matrix4 modelView,
    Vector3 cameraPosition,
    double aspect,
  }) _createTransforms(Size size) {
    final aspect = size.width / size.height;
    final projection = cameraState.getProjectionMatrix(aspect);
    final view = cameraState.getViewMatrix();
    final model = Matrix4.identity();
    final mvp = projection * view * model;
    final modelView = view * model;
    final cameraPosition = cameraState.getCameraPosition();

    return (
      mvp: mvp,
      modelView: modelView,
      cameraPosition: cameraPosition,
      aspect: aspect,
    );
  }

  // Create and fill uniform buffer
  gpu.DeviceBuffer _createUniformBuffer({
    required Matrix4 mvp,
    required Matrix4 modelView,
    required Vector3 cameraPosition,
  }) {
    final uniformData = Float32List(16 + 16 + 4);
    int offset = 0;

    // Pass MVP matrix
    uniformData.setAll(offset, mvp.storage);
    offset += 16;

    // Pass model-view matrix
    uniformData.setAll(offset, modelView.storage);
    offset += 16;

    // Pass camera position
    uniformData[offset++] = cameraPosition.x;
    uniformData[offset++] = cameraPosition.y;
    uniformData[offset++] = cameraPosition.z;
    uniformData[offset++] = 1.0;

    return gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(uniformData),
    )!;
  }

  // Create and fill texture params uniform buffer
  gpu.DeviceBuffer _createTextureParamsBuffer() {
    final uniformData = Int32List(1); // Single int for texture size
    uniformData[0] = heightmapTexture.width; // Assuming square texture

    return gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(uniformData),
    )!;
  }

  // Set up render pass with common settings
  (gpu.CommandBuffer, gpu.RenderPass) _setupRenderPass(gpu.RenderTarget renderTarget) {
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);
    renderPass.setDepthWriteEnable(true);
    renderPass.setDepthCompareOperation(gpu.CompareFunction.less);
    return (commandBuffer, renderPass);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Create a texture to render our scene into
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
    )!;

    // Create a depth texture for depth testing
    final depthTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      format: gpu.gpuContext.defaultDepthStencilFormat,
    );

    if (depthTexture == null) {
      throw Exception('Failed to create depth texture');
    }

    // Set up the render target
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

    // Create common resources
    final transforms = _createTransforms(size);
    final uniformBuffer = _createUniformBuffer(
      mvp: transforms.mvp,
      modelView: transforms.modelView,
      cameraPosition: transforms.cameraPosition,
    );
    final textureParamsBuffer = _createTextureParamsBuffer();

    // Create a full-screen quad
    final vertices = Float32List.fromList([
      -1.0, -1.0, // Bottom left
      1.0, -1.0, // Bottom right
      -1.0, 1.0, // Top left
      1.0, 1.0, // Top right
    ]);

    final verticesBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(vertices),
    )!;

    // Get shaders and create pipeline
    final vert = shaderLibrary['RaymarchVertex']!;
    final frag = shaderLibrary['RaymarchFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    // Set up render pass
    final (commandBuffer, renderPass) = _setupRenderPass(renderTarget);

    // Bind pipeline and buffers
    renderPass.bindPipeline(pipeline);
    renderPass.bindVertexBuffer(
      gpu.BufferView(
        verticesBuffer,
        offsetInBytes: 0,
        lengthInBytes: verticesBuffer.sizeInBytes,
      ),
      vertices.length ~/ 2,
    );

    // Bind vertex shader uniforms
    final vertTransformsSlot = vert.getUniformSlot('Transforms');
    renderPass.bindUniform(
      vertTransformsSlot,
      gpu.BufferView(
        uniformBuffer,
        offsetInBytes: 0,
        lengthInBytes: uniformBuffer.sizeInBytes,
      ),
    );

    // Bind fragment shader texture
    final heightmapSlot = frag.getUniformSlot('heightmapTexture');
    renderPass.bindTexture(
      heightmapSlot,
      heightmapTexture,
    );

    // Bind texture params uniform
    final textureParamsSlot = frag.getUniformSlot('TextureParams');
    renderPass.bindUniform(
      textureParamsSlot,
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

    // Draw the result to the canvas
    final image = texture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant RaymarchedTerrainPainter oldDelegate) {
    return true; // Always repaint when camera changes
  }
}
