import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/terrain_settings_provider/terrain_settings_provider.dart';
import 'package:island_gen_flutter/features/terrain_viewer/orbit_camera.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_mesh.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_painter.dart';

class TerrainViewer extends ConsumerStatefulWidget {
  const TerrainViewer({super.key});

  @override
  ConsumerState<TerrainViewer> createState() => _TerrainViewerState();
}

class _TerrainViewerState extends ConsumerState<TerrainViewer> {
  final OrbitCamera camera = OrbitCamera();
  double _lastScale = 1.0;
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
    //debugPrint('rebuildTerrain');
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

  void _handleScaleStart(ScaleStartDetails details) {
    _lastScale = 1.0;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Handle rotation
      if (details.scale == 1.0) {
        camera.orbit(
          details.focalPointDelta.dx * 0.01,
          -details.focalPointDelta.dy * 0.01,
        );
      }

      // Handle zoom
      if (details.scale != 1.0) {
        final double delta = details.scale / _lastScale;
        camera.zoom(1.0 / delta); // Invert delta for natural zoom direction
        _lastScale = details.scale;
      }
    });
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        // Zoom in/out based on scroll direction
        final double zoomDelta = event.scrollDelta.dy > 0 ? 1.1 : 0.9;
        camera.zoom(zoomDelta);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to heightmap changes
    ref.listen(heightmapDataProvider, (previous, next) {
      if (next.hasValue && next != previous) {
        _rebuildTerrain(next.requireValue);
      }
    });

    ref.listen(terrainSettingsProvider, (previous, next) {
      if (previous != null && next != previous && next.autoRebuild && _terrainMesh != null) {
        final heightmap = ref.read(heightmapDataProvider);
        if (heightmap.hasValue) {
          _rebuildTerrain(heightmap.requireValue);
        }
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

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        child: CustomPaint(
          painter: TerrainPainter(
            terrainMesh: _terrainMesh!,
            camera: camera,
            renderMode: ref.read(terrainSettingsProvider).renderMode,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
