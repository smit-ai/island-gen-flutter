import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:island_gen_flutter/models/layer.dart';

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
  void didUpdateWidget(HeightmapRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update the image if the heightmap or resolution has changed
    if (oldWidget.heightmap != widget.heightmap || oldWidget.resolution != widget.resolution) {
      print('didUpdateWidget: Updating image');
      _updateImage();
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState');
    _updateImage();
  }

  void _updateImage() {
    if (widget.heightmap.isEmpty) return;

    final width = widget.resolution.width.toInt();
    final height = widget.resolution.height.toInt();
    final pixels = Uint8List(width * height * 4);

    // Convert heightmap to RGBA pixels
    for (var i = 0; i < widget.heightmap.length; i++) {
      final value = (widget.heightmap[i] * 255).round();
      final pixelIndex = i * 4;
      pixels[pixelIndex] = value; // R
      pixels[pixelIndex + 1] = value; // G
      pixels[pixelIndex + 2] = value; // B
      pixels[pixelIndex + 3] = 255; // A
    }

    // Create image synchronously using ImageDescriptor and Codec
    ui.ImmutableBuffer.fromUint8List(pixels).then((buffer) {
      ui.ImageDescriptor.raw(
        buffer,
        width: width,
        height: height,
        pixelFormat: ui.PixelFormat.rgba8888,
      ).instantiateCodec().then((codec) {
        codec.getNextFrame().then((frame) {
          setState(() {
            _image = frame.image;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('heightmap: ${widget.heightmap.length}');
    if (_image == null) return const SizedBox.shrink();
    print('Render custom painter');
    return CustomPaint(
      painter: HeightmapPainter(
        image: _image,
        resolution: widget.resolution,
      ),
    );
  }
}

class HeightmapPainter extends CustomPainter {
  final ui.Image? image;
  final Size resolution;

  HeightmapPainter({
    required this.image,
    required this.resolution,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) return;

    final width = resolution.width;
    final height = resolution.height;

    // Calculate scaling to fit while maintaining aspect ratio
    final scale = size.width / width;
    final scaledHeight = height * scale;
    final yOffset = (size.height - scaledHeight) / 2;

    canvas.drawImageRect(
      image!,
      Rect.fromLTWH(0, 0, width, height),
      Rect.fromLTWH(0, yOffset, size.width, scaledHeight),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant HeightmapPainter oldDelegate) {
    return image != oldDelegate.image;
  }
}
