import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart';

class TerrainMesh {
  final Float32List vertices;
  final Uint32List indices;
  final Uint32List lineIndices;
  final int gridSize;
  final Duration generationTime;

  TerrainMesh({
    required this.vertices,
    required this.indices,
    required this.lineIndices,
    required this.gridSize,
    required this.generationTime,
  });

  static Future<TerrainMesh> create({
    required ui.Image heightmap,
    double width = 10.0,
    double height = 2.0,
    double depth = 10.0,
    int resolution = 100,
  }) async {
    final stopwatch = Stopwatch()..start();
    print('Creating terrain mesh with resolution: $resolution');

    // Get heightmap data
    ByteData? bytes;
    try {
      bytes = await heightmap.toByteData();
    } catch (e) {
      throw Exception('Failed to get heightmap byte data: $e');
    }
    if (bytes == null) throw Exception('Failed to get heightmap data');

    final gridX = resolution;
    final gridZ = resolution;

    // Create vertices array: position (3) + normal (3) + uv (2)
    final vertices = Float32List(gridX * gridZ * 8);
    int vIndex = 0;

    // Create vertices
    for (int z = 0; z < gridZ; z++) {
      for (int x = 0; x < gridX; x++) {
        // Calculate position
        final xPos = (x / (gridX - 1) - 0.5) * width;
        final zPos = (z / (gridZ - 1) - 0.5) * depth;

        // Get height from heightmap
        final imgX = (x / (gridX - 1) * (heightmap.width - 1)).round();
        final imgY = (z / (gridZ - 1) * (heightmap.height - 1)).round();
        final pixel = bytes.getUint8((imgY * heightmap.width + imgX) * 4);
        final yPos = (pixel / 255.0 - 0.5) * height;

        // Calculate normal
        final normal = _calculateNormal(x, z, gridX, gridZ, vertices, width, height, depth);

        // Store vertex data
        vertices[vIndex++] = xPos;
        vertices[vIndex++] = yPos;
        vertices[vIndex++] = zPos;
        vertices[vIndex++] = normal.x;
        vertices[vIndex++] = normal.y;
        vertices[vIndex++] = normal.z;
        vertices[vIndex++] = x / (gridX - 1);
        vertices[vIndex++] = z / (gridZ - 1);
      }
    }

    // Create triangle indices
    final indices = Uint32List((gridX - 1) * (gridZ - 1) * 6);
    int iIndex = 0;

    for (int z = 0; z < gridZ - 1; z++) {
      for (int x = 0; x < gridX - 1; x++) {
        final topLeft = z * gridX + x;
        final topRight = topLeft + 1;
        final bottomLeft = (z + 1) * gridX + x;
        final bottomRight = bottomLeft + 1;

        // First triangle
        indices[iIndex++] = topLeft;
        indices[iIndex++] = bottomLeft;
        indices[iIndex++] = topRight;

        // Second triangle
        indices[iIndex++] = topRight;
        indices[iIndex++] = bottomLeft;
        indices[iIndex++] = bottomRight;
      }
    }

    // Create line indices for wireframe
    final lineIndices = Uint32List((gridX - 1) * gridZ * 2 + gridX * (gridZ - 1) * 2);
    int lIndex = 0;

    // Horizontal lines
    for (int z = 0; z < gridZ; z++) {
      for (int x = 0; x < gridX - 1; x++) {
        final start = z * gridX + x;
        final end = start + 1;
        lineIndices[lIndex++] = start;
        lineIndices[lIndex++] = end;
      }
    }

    // Vertical lines
    for (int x = 0; x < gridX; x++) {
      for (int z = 0; z < gridZ - 1; z++) {
        final start = z * gridX + x;
        final end = start + gridX;
        lineIndices[lIndex++] = start;
        lineIndices[lIndex++] = end;
      }
    }

    stopwatch.stop();
    final generationTime = stopwatch.elapsed;
    print('Mesh generation completed in ${generationTime.inMilliseconds}ms');
    print('  Vertices: ${vertices.length ~/ 8}');
    print('  Triangles: ${indices.length ~/ 3}');
    print('  Lines: ${lineIndices.length ~/ 2}');

    return TerrainMesh(
      vertices: vertices,
      indices: indices,
      lineIndices: lineIndices,
      gridSize: resolution,
      generationTime: generationTime,
    );
  }

  static Vector3 _calculateNormal(
    int x,
    int z,
    int gridX,
    int gridZ,
    Float32List vertices,
    double width,
    double height,
    double depth,
  ) {
    // Calculate normal based on surrounding vertices
    final pos = Vector3(
      (x / (gridX - 1) - 0.5) * width,
      0,
      (z / (gridZ - 1) - 0.5) * depth,
    );

    final right = Vector3(
      ((x + 1).clamp(0, gridX - 1) / (gridX - 1) - 0.5) * width,
      0,
      (z / (gridZ - 1) - 0.5) * depth,
    );

    final forward = Vector3(
      (x / (gridX - 1) - 0.5) * width,
      0,
      ((z + 1).clamp(0, gridZ - 1) / (gridZ - 1) - 0.5) * depth,
    );

    final tangent = right - pos;
    final bitangent = forward - pos;
    return tangent.cross(bitangent).normalized();
  }
}
