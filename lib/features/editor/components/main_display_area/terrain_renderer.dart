import 'package:flutter/material.dart';

class TerrainRenderer extends StatelessWidget {
  final List<double> heightmap;
  final Size resolution;

  const TerrainRenderer({
    Key? key,
    required this.heightmap,
    required this.resolution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for 3D terrain
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Text(
          '3D Terrain View\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
