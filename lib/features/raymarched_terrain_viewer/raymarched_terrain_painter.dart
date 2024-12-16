import 'dart:typed_data';

import 'package:flutter/material.dart' hide Matrix4;
import 'dart:ui' as ui;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/camera/camera_state_provider.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:vector_math/vector_math.dart';

class RaymarchedTerrainPainter extends CustomPainter {
  final CameraState cameraState;
  final ui.Image heightmap;

  const RaymarchedTerrainPainter({
    required this.cameraState,
    required this.heightmap,
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

  @override
  void paint(Canvas canvas, Size size) {
    // Create a texture to render our scene into
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
    )!;

    // Set up the render target
    final renderTarget = gpu.RenderTarget.singleColor(
      gpu.ColorAttachment(
        texture: texture,
        clearValue: Vector4(0.1, 0.1, 0.1, 1.0),
      ),
    );

    // Create command buffer and render pass
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);

    // Get transforms
    final transforms = _createTransforms(size);

    // Create uniform buffer
    final uniformBuffer = _createUniformBuffer(
      mvp: transforms.mvp,
      modelView: transforms.modelView,
      cameraPosition: transforms.cameraPosition,
    );

    // Get shaders and create pipeline
    final vert = shaderLibrary['RaymarchVertex']!;
    final frag = shaderLibrary['RaymarchFragment']!;
    final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);

    // Create a full-screen quad
    final vertices = Float32List.fromList([
      // positions (x, y)
      -1.0, -1.0,
      1.0, -1.0,
      -1.0, 1.0,
      1.0, 1.0,
    ]);

    final verticesBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(vertices),
    )!;

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

    // Bind uniforms
    renderPass.bindUniform(
      vert.getUniformSlot('Transforms'),
      gpu.BufferView(
        uniformBuffer,
        offsetInBytes: 0,
        lengthInBytes: uniformBuffer.sizeInBytes,
      ),
    );

    renderPass.bindUniform(
      frag.getUniformSlot('Transforms'),
      gpu.BufferView(
        uniformBuffer,
        offsetInBytes: 0,
        lengthInBytes: uniformBuffer.sizeInBytes,
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
