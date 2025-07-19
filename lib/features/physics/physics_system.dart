import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/shaders.dart';
import 'package:island_gen_flutter/features/physics/physics_body.dart';
import 'package:vector_math/vector_math_64.dart';

class PhysicsSystem {
  // Singleton instance
  static final PhysicsSystem _instance = PhysicsSystem._internal();
  static PhysicsSystem get instance => _instance;
  
  // Factory constructor
  factory PhysicsSystem() => _instance;
  
  // Internal constructor
  PhysicsSystem._internal();
  
  // Initialize system
  static Future<void> initialize() async {
    await _instance._initializeGPUResources();
  }
  
  // Physics state
  final List<PhysicsBody> _bodies = [];
  Timer? _simulationTimer;
  bool _isSimulationRunning = false;
  double _timeStep = 1/60; // 60 fps
  
  // GPU resources
  late gpu.RenderPipeline _positionUpdatePipeline;
  late gpu.RenderPipeline _collisionDetectPipeline;
  
  // Textures for physics state
  late gpu.Texture _positionTexture;
  late gpu.Texture _velocityTexture;
  late gpu.Texture _forceTexture;
  late gpu.Texture _bodyPropsTexture;
  late gpu.Texture _tempTexture;
  
  // Buffers
  late gpu.DeviceBuffer _quadVertexBuffer;
  
  // Constants
  final Vector3 _gravity = Vector3(0, -9.8, 0);
  final int _maxBodies = 1024; // Maximum number of bodies (texture resolution)
  
  // Initialize GPU resources
  Future<void> _initializeGPUResources() async {
    try {
      // Create pipelines
      final posUpdateVert = shaderLibrary['PositionUpdateVertex']!;
      final posUpdateFrag = shaderLibrary['PositionUpdateFragment']!;
      _positionUpdatePipeline = gpu.gpuContext.createRenderPipeline(posUpdateVert, posUpdateFrag);
      
      final collisionVert = shaderLibrary['CollisionDetectVertex']!;
      final collisionFrag = shaderLibrary['CollisionDetectFragment']!;
      _collisionDetectPipeline = gpu.gpuContext.createRenderPipeline(collisionVert, collisionFrag);
      
      // Create textures
      const textureWidth = 32; // sqrt(1024)
      const textureHeight = 32;
      
      _positionTexture = gpu.gpuContext.createTexture(
        gpu.TextureDescriptor(
          format: gpu.TextureFormat.rgba32float,
          width: textureWidth,
          height: textureHeight,
          usage: gpu.TextureUsage.renderTarget | gpu.TextureUsage.texture,
        ),
      );
      
      _velocityTexture = gpu.gpuContext.createTexture(
        gpu.TextureDescriptor(
          format: gpu.TextureFormat.rgba32float,
          width: textureWidth,
          height: textureHeight,
          usage: gpu.TextureUsage.renderTarget | gpu.TextureUsage.texture,
        ),
      );
      
      _forceTexture = gpu.gpuContext.createTexture(
        gpu.TextureDescriptor(
          format: gpu.TextureFormat.rgba32float,
          width: textureWidth,
          height: textureHeight,
          usage: gpu.TextureUsage.renderTarget | gpu.TextureUsage.texture,
        ),
      );
      
      _bodyPropsTexture = gpu.gpuContext.createTexture(
        gpu.TextureDescriptor(
          format: gpu.TextureFormat.rgba32float,
          width: textureWidth,
          height: textureHeight,
          usage: gpu.TextureUsage.renderTarget | gpu.TextureUsage.texture,
        ),
      );
      
      _tempTexture = gpu.gpuContext.createTexture(
        gpu.TextureDescriptor(
          format: gpu.TextureFormat.rgba32float,
          width: textureWidth,
          height: textureHeight,
          usage: gpu.TextureUsage.renderTarget | gpu.TextureUsage.texture,
        ),
      );
      
      // Create quad vertex buffer
      final quadVertices = Float32List.fromList([
        -1.0, -1.0,  // Bottom-left
         1.0, -1.0,  // Bottom-right
         1.0,  1.0,  // Top-right
        -1.0,  1.0,  // Top-left
      ]);
      
      _quadVertexBuffer = gpu.gpuContext.createBuffer(
        gpu.BufferDescriptor(
          size: quadVertices.lengthInBytes,
          usage: gpu.BufferUsage.vertex,
        ),
      );
      
      _quadVertexBuffer.setFloat32List(0, quadVertices);
      
      debugPrint('GPU resources initialized for physics system');
    } catch (e) {
      debugPrint('Error initializing GPU resources: $e');
      rethrow;
    }
  }
  
  // Add a physics body
  void addBody(PhysicsBody body) {
    if (_bodies.length >= _maxBodies) {
      debugPrint('Maximum number of bodies reached');
      return;
    }
    _bodies.add(body);
    _updatePhysicsTextures();
  }
  
  // Remove a physics body
  void removeBody(String id) {
    _bodies.removeWhere((body) => body.id == id);
    _updatePhysicsTextures();
  }
  
  // Update physics textures with current body data
  void _updatePhysicsTextures() {
    // Create data arrays
    final positions = Float32List(_maxBodies * 4);
    final velocities = Float32List(_maxBodies * 4);
    final forces = Float32List(_maxBodies * 4);
    final bodyProps = Float32List(_maxBodies * 4);
    
    // Fill data
    for (int i = 0; i < _bodies.length; i++) {
      final body = _bodies[i];
      
      // Position (xyz, w unused)
      positions[i * 4] = body.position.x;
      positions[i * 4 + 1] = body.position.y;
      positions[i * 4 + 2] = body.position.z;
      positions[i * 4 + 3] = 1.0;
      
      // Velocity (xyz, w unused)
      velocities[i * 4] = body.velocity.x;
      velocities[i * 4 + 1] = body.velocity.y;
      velocities[i * 4 + 2] = body.velocity.z;
      velocities[i * 4 + 3] = 0.0;
      
      // Force (xyz, w unused)
      forces[i * 4] = body.force.x;
      forces[i * 4 + 1] = body.force.y;
      forces[i * 4 + 2] = body.force.z;
      forces[i * 4 + 3] = 0.0;
      
      // Body properties (mass, restitution, friction, isStatic)
      bodyProps[i * 4] = body.mass;
      bodyProps[i * 4 + 1] = body.restitution;
      bodyProps[i * 4 + 2] = body.friction;
      bodyProps[i * 4 + 3] = body.isStatic ? 1.0 : 0.0;
    }
    
    // Upload to textures
    // In a real implementation, we would need to create staging buffers and copy data more efficiently
    // This is simplified for demonstration purposes
    
    // For now in this example, we'll rely on CPU physics until compute shaders are supported
  }
  
  // Start simulation
  void startSimulation() {
    if (_isSimulationRunning) return;
    
    _isSimulationRunning = true;
    _simulationTimer = Timer.periodic(
      Duration(milliseconds: (_timeStep * 1000).round()),
      (_) => _updatePhysics(),
    );
  }
  
  // Stop simulation
  void stopSimulation() {
    _isSimulationRunning = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }
  
  // Single step simulation
  void stepSimulation() {
    _updatePhysics();
  }
  
  // Update physics state
  void _updatePhysics() {
    // For now, use CPU physics until compute shaders are fully supported
    _updatePhysicsCPU();
    
    // Update visualization data after physics update
    _updatePhysicsTextures();
  }
  
  // CPU-based physics update
  void _updatePhysicsCPU() {
    // Apply forces
    for (final body in _bodies) {
      if (body.isStatic) continue;
      
      // Apply gravity
      body.force += _gravity * body.mass;
      
      // Update velocity
      body.velocity += body.force * (1.0 / body.mass) * _timeStep;
      
      // Clear forces for next step
      body.force = Vector3.zero();
    }
    
    // Detect and resolve collisions
    _detectCollisions();
    
    // Update positions
    for (final body in _bodies) {
      if (body.isStatic) continue;
      
      // Update position
      body.position += body.velocity * _timeStep;
    }
  }
  
  // Basic collision detection and response
  void _detectCollisions() {
    // Check for ground plane collisions
    for (final body in _bodies) {
      if (body.isStatic) continue;
      
      // Simple ground collision (y=0)
      if (body.position.y - body.shape.radius < 0) {
        // Collision response: reflect velocity with restitution
        body.velocity.y = body.velocity.y.abs() * body.restitution;
        body.position.y = body.shape.radius; // Place on ground
      }
    }
    
    // Check for sphere-sphere collisions
    for (int i = 0; i < _bodies.length; i++) {
      final bodyA = _bodies[i];
      if (bodyA.isStatic) continue;
      
      for (int j = i + 1; j < _bodies.length; j++) {
        final bodyB = _bodies[j];
        
        // Calculate distance between centers
        final delta = bodyB.position - bodyA.position;
        final distance = delta.length;
        
        // Check if colliding
        final minDistance = bodyA.shape.radius + bodyB.shape.radius;
        if (distance < minDistance) {
          // Calculate collision normal
          final normal = delta.normalized();
          
          // Calculate relative velocity
          final relativeVelocity = bodyB.velocity - bodyA.velocity;
          
          // Calculate impulse
          final impulseMagnitude = -(1 + bodyA.restitution) * relativeVelocity.dot(normal) /
              ((1 / bodyA.mass) + (1 / bodyB.mass));
          
          // Apply impulse
          if (!bodyA.isStatic) {
            bodyA.velocity -= normal * (impulseMagnitude / bodyA.mass);
          }
          
          if (!bodyB.isStatic) {
            bodyB.velocity += normal * (impulseMagnitude / bodyB.mass);
          }
          
          // Resolve penetration
          final penetration = minDistance - distance;
          final correctionPercentage = 0.2; // Penetration resolution factor
          final correction = normal * (penetration * correctionPercentage);
          
          if (!bodyA.isStatic) {
            bodyA.position -= correction * (bodyA.mass / (bodyA.mass + bodyB.mass));
          }
          
          if (!bodyB.isStatic) {
            bodyB.position += correction * (bodyB.mass / (bodyA.mass + bodyB.mass));
          }
        }
      }
    }
  }
  
  // Get physics body by ID
  PhysicsBody? getBody(String id) {
    for (final body in _bodies) {
      if (body.id == id) return body;
    }
    return null;
  }
  
  // Get all bodies
  List<PhysicsBody> get bodies => List.unmodifiable(_bodies);
}
