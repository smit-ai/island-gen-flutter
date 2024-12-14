import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HeightmapPainter extends CustomPainter {
  final ui.Image heightmap;

  const HeightmapPainter({
    required this.heightmap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scaling to fit the image while maintaining aspect ratio
    final double scale = size.width / heightmap.width;
    final double scaledHeight = heightmap.height * scale;

    // Center the image vertically if needed
    final double yOffset = (size.height - scaledHeight) / 2;

    final rect = Rect.fromLTWH(0, yOffset, size.width, scaledHeight);
    canvas.drawImageRect(
      heightmap,
      Rect.fromLTWH(0, 0, heightmap.width.toDouble(), heightmap.height.toDouble()),
      rect,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant HeightmapPainter oldDelegate) {
    return oldDelegate.heightmap != heightmap;
  }
}
