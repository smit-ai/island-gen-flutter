import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui' show FragmentProgram;
import 'dart:ui' show FragmentShader;
import 'package:flutter/material.dart';
import 'package:island_gen_flutter/models/layer.dart';

class GpuNoiseGenerator {
  static FragmentProgram? _program;
  static FragmentShader? _shader;

  static Future<void> _initShader() async {
    if (_program == null) {
      _program = await FragmentProgram.fromAsset('shaders/noise.frag');
      _shader = _program!.fragmentShader();
    }
  }

  static Future<List<double>> generateHeightmap(Layer layer, Size resolution) async {
    await _initShader();

    final shader = _shader!;
    // Set uniforms
    shader.setFloat(0, resolution.width);
    shader.setFloat(1, resolution.height);
    shader.setFloat(2, layer.noise.frequency);
    shader.setFloat(3, layer.noise.persistence);
    shader.setFloat(4, layer.noise.lacunarity);
    shader.setFloat(5, layer.noise.octaves.toDouble());
    shader.setFloat(6, layer.noise.seed.toDouble());
    shader.setFloat(7, layer.noise.type.index.toDouble());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw using the shader
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, resolution.width, resolution.height),
      paint,
    );

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      resolution.width.toInt(),
      resolution.height.toInt(),
    );

    final byteData = await image.toByteData();
    if (byteData == null) {
      throw Exception('Failed to retrieve byte data from image');
    }

    final pixels = byteData.buffer.asUint8List();
    final size = resolution.width.toInt() * resolution.height.toInt();
    final heightmap = Float32List(size);

    // Convert RGBA to single-channel heightmap (using the red channel)
    for (var i = 0; i < size; i++) {
      heightmap[i] = pixels[i * 4] / 255.0;
    }

    return heightmap;
  }
}
