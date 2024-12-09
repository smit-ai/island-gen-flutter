import 'dart:ui' as ui;
import 'dart:ui' show FragmentProgram;
import 'package:flutter/material.dart';
import 'package:island_gen_flutter/models/layer.dart';

class GpuNoiseGenerator {
  static Future<List<double>> generateHeightmap(Layer layer, Size resolution) async {
    final program = await FragmentProgram.fromAsset('shaders/noise.frag');
    final shader = program.fragmentShader();

    // Set uniforms
    shader.setFloat(0, resolution.width);
    shader.setFloat(1, resolution.height);
    shader.setFloat(2, layer.noise.frequency);
    shader.setFloat(3, layer.noise.persistence);
    shader.setFloat(4, layer.noise.lacunarity);
    shader.setFloat(5, layer.noise.octaves.toDouble());
    shader.setFloat(6, layer.noise.seed.toDouble());
    shader.setFloat(7, layer.noise.type.index.toDouble());

    final size = resolution.width.toInt() * resolution.height.toInt();
    final heightmap = List<double>.filled(size, 0.0);

    // Create a picture recorder and canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw using the shader
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, resolution.width, resolution.height),
      paint,
    );

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      resolution.width.toInt(),
      resolution.height.toInt(),
    );

    // Read pixels
    final byteData = await image.toByteData();
    if (byteData == null) throw Exception('Failed to read image data');

    // Convert RGBA to heightmap values (using only red channel)
    final pixels = byteData.buffer.asUint8List();
    for (var i = 0; i < size; i++) {
      heightmap[i] = pixels[i * 4] / 255.0;
    }

    return heightmap;
  }
}
