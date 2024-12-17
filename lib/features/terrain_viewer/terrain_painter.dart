import 'dart:typed_data';
import 'package:flutter/material.dart' hide Matrix4;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/camera/camera_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:vector_math/vector_math.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_mesh.dart';

class TerrainPainter extends CustomPainter {
  final TerrainMesh terrainMesh;
  final CameraState cameraState;
  final ViewMode viewMode;

  const TerrainPainter({
    required this.terrainMesh,
    required this.cameraState,
    required this.viewMode,
  });

  // Create vertex and index buffers
  (gpu.DeviceBuffer, gpu.DeviceBuffer, gpu.DeviceBuffer) _createBuffers() {
    final verticesBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(terrainMesh.vertices),
    )!;

    final indexBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(terrainMesh.indices),
    )!;

    final lineIndexBuffer = gpu.gpuContext.createDeviceBufferWithCopy(
      ByteData.sublistView(terrainMesh.lineIndices),
    )!;

    return (verticesBuffer, indexBuffer, lineIndexBuffer);
  }

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
    required Vector3 lightColor,
    required double ambientStrength,
    required double specularStrength,
    required bool isWireframe,
  }) {
    final uniformData = Float32List(16 + 16 + 4 + 4 + 4);
    int offset = 0;

    // Pass MVP matrix
    uniformData.setAll(offset, mvp.storage);
    offset += 16;

    // Pass model-view matrix
    uniformData.setAll(offset, modelView.storage);
    offset += 16;

    // Pass light position
    final lightPositionWorld = cameraPosition + Vector3(5.0, 5.0, 0.0);
    uniformData[offset++] = lightPositionWorld.x;
    uniformData[offset++] = lightPositionWorld.y;
    uniformData[offset++] = lightPositionWorld.z;
    uniformData[offset++] = 1.0;

    // Pass light color
    uniformData[offset++] = lightColor.x;
    uniformData[offset++] = lightColor.y;
    uniformData[offset++] = lightColor.z;
    uniformData[offset++] = 0.0;

    // Pass parameters
    uniformData[offset++] = ambientStrength;
    uniformData[offset++] = specularStrength;
    uniformData[offset++] = terrainMesh.gridSize.toDouble();
    final modeFlag = isWireframe ? 1.0 : 0.0;
    //print('Creating uniform buffer with isWireframe: $isWireframe, modeFlag: $modeFlag');
    uniformData[offset++] = modeFlag;

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
    // Create a texture to render our 3D scene into
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
      format: gpu.PixelFormat.r16g16b16a16Float,
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
    final (verticesBuffer, indexBuffer, lineIndexBuffer) = _createBuffers();
    final transforms = _createTransforms(size);

    switch (viewMode) {
      case ViewMode.view2D:
      case ViewMode.raymarched3D:
        return;
      case ViewMode.wireframe3D:
        {
          final uniformBuffer = _createUniformBuffer(
            mvp: transforms.mvp,
            modelView: transforms.modelView,
            cameraPosition: transforms.cameraPosition,
            lightColor: Vector3(1.0, 1.0, 1.0),
            ambientStrength: 0.3,
            specularStrength: 0.7,
            isWireframe: true,
          );

          // Get shaders and create pipeline
          final vert = shaderLibrary['TerrainVertex']!;
          final frag = shaderLibrary['WireframeFragment']!;
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
            terrainMesh.vertices.length ~/ 8,
          );

          // Bind uniforms to both vertex and fragment shaders
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

          // Draw wireframe
          renderPass.bindIndexBuffer(
            gpu.BufferView(
              lineIndexBuffer,
              offsetInBytes: 0,
              lengthInBytes: lineIndexBuffer.sizeInBytes,
            ),
            gpu.IndexType.int16,
            terrainMesh.lineIndices.length,
          );
          renderPass.setPrimitiveType(gpu.PrimitiveType.line);
          renderPass.draw();

          commandBuffer.submit();
        }
        break;

      case ViewMode.solid3D:
        {
          // Create separate uniform buffers for terrain and wireframe
          final terrainUniformBuffer = _createUniformBuffer(
            mvp: transforms.mvp,
            modelView: transforms.modelView,
            cameraPosition: transforms.cameraPosition,
            lightColor: Vector3(1.0, 1.0, 1.0),
            ambientStrength: 0.3,
            specularStrength: 0.7,
            isWireframe: false,
          );

          final wireframeUniformBuffer = _createUniformBuffer(
            mvp: transforms.mvp,
            modelView: transforms.modelView,
            cameraPosition: transforms.cameraPosition,
            lightColor: Vector3(1.0, 1.0, 1.0),
            ambientStrength: 0.3,
            specularStrength: 0.7,
            isWireframe: false,
          );

          // Get shaders and create pipeline
          final vert = shaderLibrary['TerrainVertex']!;
          final frag = shaderLibrary['TerrainFragment']!;
          final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);
          final wireFrag = shaderLibrary['WireframeFragment']!;
          final wirePipeline = gpu.gpuContext.createRenderPipeline(vert, wireFrag);

          // Set up render pass
          final (commandBuffer, renderPass) = _setupRenderPass(renderTarget);

          // First draw: solid terrain
          renderPass.bindPipeline(pipeline);
          renderPass.bindVertexBuffer(
            gpu.BufferView(
              verticesBuffer,
              offsetInBytes: 0,
              lengthInBytes: verticesBuffer.sizeInBytes,
            ),
            terrainMesh.vertices.length ~/ 8,
          );

          // Bind uniforms with terrain buffer
          renderPass.bindUniform(
            vert.getUniformSlot('Transforms'),
            gpu.BufferView(
              terrainUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: terrainUniformBuffer.sizeInBytes,
            ),
          );

          renderPass.bindUniform(
            frag.getUniformSlot('Transforms'),
            gpu.BufferView(
              terrainUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: terrainUniformBuffer.sizeInBytes,
            ),
          );

          // Draw triangles
          renderPass.bindIndexBuffer(
            gpu.BufferView(
              indexBuffer,
              offsetInBytes: 0,
              lengthInBytes: indexBuffer.sizeInBytes,
            ),
            gpu.IndexType.int16,
            terrainMesh.indices.length,
          );
          renderPass.setPrimitiveType(gpu.PrimitiveType.triangle);
          renderPass.draw();

          // Second draw: wireframe lines
          renderPass.bindPipeline(wirePipeline);
          renderPass.bindVertexBuffer(
            gpu.BufferView(
              verticesBuffer,
              offsetInBytes: 0,
              lengthInBytes: verticesBuffer.sizeInBytes,
            ),
            terrainMesh.vertices.length ~/ 8,
          );

          // Enable alpha blending for wireframe
          renderPass.setColorBlendEnable(true);
          renderPass.setColorBlendEquation(
            gpu.ColorBlendEquation(
              sourceColorBlendFactor: gpu.BlendFactor.one,
              destinationColorBlendFactor: gpu.BlendFactor.oneMinusSourceAlpha,
            ),
          );

          // Bind uniforms with wireframe buffer
          renderPass.bindUniform(
            vert.getUniformSlot('Transforms'),
            gpu.BufferView(
              wireframeUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: wireframeUniformBuffer.sizeInBytes,
            ),
          );

          renderPass.bindUniform(
            frag.getUniformSlot('Transforms'),
            gpu.BufferView(
              wireframeUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: wireframeUniformBuffer.sizeInBytes,
            ),
          );

          // Draw wireframe lines
          renderPass.bindIndexBuffer(
            gpu.BufferView(
              lineIndexBuffer,
              offsetInBytes: 0,
              lengthInBytes: lineIndexBuffer.sizeInBytes,
            ),
            gpu.IndexType.int16,
            terrainMesh.lineIndices.length,
          );
          renderPass.setPrimitiveType(gpu.PrimitiveType.line);
          renderPass.draw();

          commandBuffer.submit();
        }
        break;

      case ViewMode.color3D:
        {
          // Create separate uniform buffers for terrain and wireframe
          final terrainUniformBuffer = _createUniformBuffer(
            mvp: transforms.mvp,
            modelView: transforms.modelView,
            cameraPosition: transforms.cameraPosition,
            lightColor: Vector3(1.0, 1.0, 1.0),
            ambientStrength: 0.3,
            specularStrength: 0.7,
            isWireframe: false,
          );

          final wireframeUniformBuffer = _createUniformBuffer(
            mvp: transforms.mvp,
            modelView: transforms.modelView,
            cameraPosition: transforms.cameraPosition,
            lightColor: Vector3(1.0, 1.0, 1.0),
            ambientStrength: 0.3,
            specularStrength: 0.7,
            isWireframe: false,
          );

          // Get shaders and create pipelines
          final vert = shaderLibrary['TerrainVertex']!;
          final frag = shaderLibrary['ColorFragment']!;
          final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);
          final wireFrag = shaderLibrary['WireframeFragment']!;
          final wirePipeline = gpu.gpuContext.createRenderPipeline(vert, wireFrag);

          // Set up render pass
          final (commandBuffer, renderPass) = _setupRenderPass(renderTarget);

          // First draw: colored terrain
          renderPass.bindPipeline(pipeline);
          renderPass.bindVertexBuffer(
            gpu.BufferView(
              verticesBuffer,
              offsetInBytes: 0,
              lengthInBytes: verticesBuffer.sizeInBytes,
            ),
            terrainMesh.vertices.length ~/ 8,
          );

          // Bind uniforms with terrain buffer
          renderPass.bindUniform(
            vert.getUniformSlot('Transforms'),
            gpu.BufferView(
              terrainUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: terrainUniformBuffer.sizeInBytes,
            ),
          );

          renderPass.bindUniform(
            frag.getUniformSlot('Transforms'),
            gpu.BufferView(
              terrainUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: terrainUniformBuffer.sizeInBytes,
            ),
          );

          // Draw triangles
          renderPass.bindIndexBuffer(
            gpu.BufferView(
              indexBuffer,
              offsetInBytes: 0,
              lengthInBytes: indexBuffer.sizeInBytes,
            ),
            gpu.IndexType.int16,
            terrainMesh.indices.length,
          );
          renderPass.setPrimitiveType(gpu.PrimitiveType.triangle);
          renderPass.draw();

          // Second draw: wireframe lines
          renderPass.bindPipeline(wirePipeline);
          renderPass.bindVertexBuffer(
            gpu.BufferView(
              verticesBuffer,
              offsetInBytes: 0,
              lengthInBytes: verticesBuffer.sizeInBytes,
            ),
            terrainMesh.vertices.length ~/ 8,
          );

          // Enable alpha blending for wireframe
          renderPass.setColorBlendEnable(true);
          renderPass.setColorBlendEquation(
            gpu.ColorBlendEquation(
              sourceColorBlendFactor: gpu.BlendFactor.one,
              destinationColorBlendFactor: gpu.BlendFactor.oneMinusSourceAlpha,
            ),
          );

          // Bind uniforms with wireframe buffer
          renderPass.bindUniform(
            vert.getUniformSlot('Transforms'),
            gpu.BufferView(
              wireframeUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: wireframeUniformBuffer.sizeInBytes,
            ),
          );

          renderPass.bindUniform(
            frag.getUniformSlot('Transforms'),
            gpu.BufferView(
              wireframeUniformBuffer,
              offsetInBytes: 0,
              lengthInBytes: wireframeUniformBuffer.sizeInBytes,
            ),
          );

          // Draw wireframe lines
          renderPass.bindIndexBuffer(
            gpu.BufferView(
              lineIndexBuffer,
              offsetInBytes: 0,
              lengthInBytes: lineIndexBuffer.sizeInBytes,
            ),
            gpu.IndexType.int16,
            terrainMesh.lineIndices.length,
          );
          renderPass.setPrimitiveType(gpu.PrimitiveType.line);
          renderPass.draw();

          commandBuffer.submit();
        }
        break;
    }

    // Draw the result to the canvas
    final image = texture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant TerrainPainter oldDelegate) {
    return true; // Always repaint when camera changes
  }
}
