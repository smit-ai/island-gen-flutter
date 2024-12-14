import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
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
    if (heightmap != null) {
      _initializeTerrain(heightmap);
    }
    super.initState();
  }

  Future<void> _initializeTerrain(ui.Image heightmap) async {
    print('initializeTerrain');
    try {
      setState(() {
        _isLoading = true;
      });

      final mesh = await TerrainMesh.create(
        heightmap: heightmap,
        width: 10.0,
        height: 2.0,
        depth: 10.0,
        resolution: 200,
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
    ref.listen(heightmapDataProvider, (previous, ui.Image? next) {
      if (next != previous && next != null) {
        _initializeTerrain(next);
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
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}
