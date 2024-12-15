import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HeightmapRenderer extends StatefulWidget {
  final List<double> heightmap;
  final Size resolution;

  const HeightmapRenderer({
    super.key,
    required this.heightmap,
    required this.resolution,
  });

  @override
  State<HeightmapRenderer> createState() => _HeightmapRendererState();
}

class _HeightmapRendererState extends State<HeightmapRenderer> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _createImageFromHeightmap();
  }

  @override
  void didUpdateWidget(HeightmapRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.heightmap != widget.heightmap || oldWidget.resolution != widget.resolution) {
      _createImageFromHeightmap();
    }
  }

  void _createImageFromHeightmap() {
    if (widget.heightmap.isEmpty) {
      setState(() {
        _image = null;
      });
      return;
    }

    final width = widget.resolution.width.toInt();
    final height = widget.resolution.height.toInt();

    final pixels = Uint8List(width * height * 4);
    for (var i = 0; i < widget.heightmap.length; i++) {
      final value = (widget.heightmap[i] * 255).toInt().clamp(0, 255);
      final pixelIndex = i * 4;
      pixels[pixelIndex] = value;
      pixels[pixelIndex + 1] = value;
      pixels[pixelIndex + 2] = value;
      pixels[pixelIndex + 3] = 255;
    }

    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (image) {
        if (!mounted) return;
        setState(() {
          _image = image;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox.shrink();
    return CustomPaint(
      painter: HeightmapPainter(
        image: _image!,
        resolution: widget.resolution,
      ),
    );
  }
}

class HeightmapPainter extends CustomPainter {
  final ui.Image image;
  final Size resolution;

  HeightmapPainter({
    required this.image,
    required this.resolution,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / resolution.width;
    final scaledHeight = resolution.height * scale;
    final yOffset = (size.height - scaledHeight) / 2;

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, resolution.width, resolution.height),
      Rect.fromLTWH(0, yOffset, size.width, scaledHeight),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(HeightmapPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
