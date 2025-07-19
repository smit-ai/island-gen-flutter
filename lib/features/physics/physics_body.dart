import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart';

enum BodyType {
  sphere,
  box,
  plane,
}

class CollisionShape {
  final BodyType type;
  final double radius; // For sphere
  final Vector3 halfExtents; // For box
  final Vector3 normal; // For plane
  
  const CollisionShape.sphere(this.radius)
      : type = BodyType.sphere,
        halfExtents = const Vector3(0, 0, 0),
        normal = const Vector3(0, 1, 0);
  
  const CollisionShape.box(this.halfExtents)
      : type = BodyType.box,
        radius = 0,
        normal = const Vector3(0, 1, 0);
  
  const CollisionShape.plane(this.normal)
      : type = BodyType.plane,
        radius = 0,
        halfExtents = const Vector3(0, 0, 0);
}

class PhysicsBody {
  final String id;
  Vector3 position;
  Vector3 velocity;
  Vector3 force;
  final double mass;
  final double restitution; // Bounciness (0-1)
  final double friction;
  final bool isStatic;
  final CollisionShape shape;
  final Color color;
  
  // GPU resources
  gpu.Texture? texture;
  gpu.DeviceBuffer? vertexBuffer;
  gpu.DeviceBuffer? indexBuffer;
  
  PhysicsBody({
    String? id,
    required this.position,
    Vector3? velocity,
    Vector3? force,
    required this.mass,
    this.restitution = 0.7,
    this.friction = 0.5,
    this.isStatic = false,
    required this.shape,
    this.color = Colors.white,
    this.texture,
    this.vertexBuffer,
    this.indexBuffer,
  }) : 
    id = id ?? const Uuid().v4(),
    velocity = velocity ?? Vector3.zero(),
    force = force ?? Vector3.zero();
  
  // Helper to create a static ground plane
  static PhysicsBody createGround({
    Vector3 position = const Vector3(0, 0, 0),
    double friction = 0.5,
    double width = 100,
    double depth = 100,
    Color color = Colors.grey,
  }) {
    return PhysicsBody(
      position: position,
      mass: 0, // 0 mass means static
      friction: friction,
      isStatic: true,
      shape: const CollisionShape.plane(Vector3(0, 1, 0)),
      color: color,
    );
  }
  
  // Helper to create a sphere
  static PhysicsBody createSphere({
    required Vector3 position,
    required double radius,
    required double mass,
    Vector3? velocity,
    double restitution = 0.7,
    double friction = 0.5,
    Color color = Colors.blue,
  }) {
    return PhysicsBody(
      position: position,
      velocity: velocity,
      mass: mass,
      restitution: restitution,
      friction: friction,
      isStatic: false,
      shape: CollisionShape.sphere(radius),
      color: color,
    );
  }
  
  // Helper to create a box
  static PhysicsBody createBox({
    required Vector3 position,
    required Vector3 size,
    required double mass,
    Vector3? velocity,
    double restitution = 0.7,
    double friction = 0.5,
    Color color = Colors.red,
  }) {
    return PhysicsBody(
      position: position,
      velocity: velocity,
      mass: mass,
      restitution: restitution,
      friction: friction,
      isStatic: false,
      shape: CollisionShape.box(size * 0.5),
      color: color,
    );
  }
}