import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/terrain_settings_provider/terrain_settings_provider.dart';
import 'package:island_gen_flutter/features/camera/camera_wrapper.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_mesh.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_painter.dart';

class TerrainViewer extends ConsumerStatefulWidget {
  const TerrainViewer({super.key});

  @override
  ConsumerState<TerrainViewer> createState() => _TerrainViewerState();
}

class _TerrainViewerState extends ConsumerState<TerrainViewer> {
  TerrainMesh? _terrainMesh;
  bool _isLoading = true;

  @override
  void initState() {
    final heightmap = ref.read(heightmapDataProvider);
    if (heightmap.hasValue) {
      _rebuildTerrain(heightmap.requireValue);
    }
    super.initState();
  }

  Future<void> _rebuildTerrain(ui.Image heightmap) async {
    try {
      final settings = ref.read(terrainSettingsProvider);

      final mesh = await TerrainMesh.create(
        heightmap: heightmap,
        width: settings.width,
        height: settings.height,
        depth: settings.depth,
        resolution: settings.gridResolution,
      );

      setState(() {
        _terrainMesh = mesh;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to heightmap changes
    ref.listen(heightmapDataProvider, (previous, next) {
      if (next.hasValue) {
        _rebuildTerrain(next.requireValue);
      }
    });

    // Listen to terrain settings changes
    ref.listen(terrainSettingsProvider, (previous, next) {
      if (previous != null && next != previous && next.autoRebuild && _terrainMesh != null) {
        final heightmap = ref.read(heightmapDataProvider);
        if (heightmap.hasValue) {
          _rebuildTerrain(heightmap.requireValue);
        }
      }
    });

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_terrainMesh == null) {
      return const Center(
        child: Text('No heightmap data'),
      );
    }

    final viewMode = ref.watch(globalSettingsProvider).viewMode;

    return CameraWrapper(
      builder: (cameraState) => CustomPaint(
        painter: TerrainPainter(
          terrainMesh: _terrainMesh!,
          cameraState: cameraState,
          viewMode: viewMode,
        ),
        size: Size.infinite,
      ),
    );
  }
}
