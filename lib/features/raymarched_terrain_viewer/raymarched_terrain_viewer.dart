import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/raymarched_terrain_viewer/raymarched_terrain_painter.dart';
import 'package:island_gen_flutter/features/camera/camera_wrapper.dart';

class RaymarchedTerrainViewer extends ConsumerStatefulWidget {
  const RaymarchedTerrainViewer({super.key});

  @override
  ConsumerState<RaymarchedTerrainViewer> createState() => _RaymarchedTerrainViewerState();
}

class _RaymarchedTerrainViewerState extends ConsumerState<RaymarchedTerrainViewer> {
  @override
  Widget build(BuildContext context) {
    final heightmapTexture = ref.watch(heightmapDataProvider);

    return CameraWrapper(
      builder: (cameraState) => CustomPaint(
        painter: RaymarchedTerrainPainter(
          cameraState: cameraState,
          heightmapTexture: heightmapTexture,
        ),
        size: Size.infinite,
      ),
    );
  }
}
