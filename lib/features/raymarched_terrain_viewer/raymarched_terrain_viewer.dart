import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/raymarched_terrain_viewer/raymarched_terrain_painter.dart';
import 'package:island_gen_flutter/features/camera/camera_wrapper.dart';
import 'package:island_gen_flutter/features/heightmap_generator/extentions.dart';

class RaymarchedTerrainViewer extends ConsumerStatefulWidget {
  const RaymarchedTerrainViewer({super.key});

  @override
  ConsumerState<RaymarchedTerrainViewer> createState() => _RaymarchedTerrainViewerState();
}

class _RaymarchedTerrainViewerState extends ConsumerState<RaymarchedTerrainViewer> {
  gpu.Texture? _heightmapTexture;

  Future<void> _updateHeightmapTexture(heightmap) async {
    _heightmapTexture = await TextureExtensions.fromImage(
      heightmap,
      gpu.PixelFormat.r8g8b8a8UNormInt,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightmap = ref.watch(heightmapDataProvider);

    // Handle heightmap changes
    ref.listen(heightmapDataProvider, (previous, next) {
      if (next.hasValue && (previous == null || previous.value != next.value)) {
        _updateHeightmapTexture(next.value);
      }
    });

    if (heightmap.isLoading || _heightmapTexture == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (heightmap.hasError) {
      return const Center(child: Text('Error loading heightmap'));
    }

    return CameraWrapper(
      builder: (cameraState) => CustomPaint(
        painter: RaymarchedTerrainPainter(
          cameraState: cameraState,
          heightmapTexture: _heightmapTexture!,
        ),
        size: Size.infinite,
      ),
    );
  }
}
