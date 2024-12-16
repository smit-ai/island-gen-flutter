import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/raymarched_terrain_viewer/raymarched_terrain_painter.dart';
import 'package:island_gen_flutter/features/camera/camera_wrapper.dart';

class RaymarchedTerrainViewer extends ConsumerWidget {
  const RaymarchedTerrainViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightmap = ref.read(heightmapDataProvider);
    if (heightmap.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (heightmap.hasError) {
      return const Center(child: Text('Error loading heightmap'));
    }

    return CameraWrapper(
      builder: (cameraState) => CustomPaint(
        painter: RaymarchedTerrainPainter(
          cameraState: cameraState,
          heightmap: heightmap.requireValue,
        ),
        size: Size.infinite,
      ),
    );
  }
}
