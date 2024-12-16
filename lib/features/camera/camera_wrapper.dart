import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/camera/camera_state_provider.dart';

class CameraWrapper extends ConsumerStatefulWidget {
  final Widget Function(CameraState cameraState) builder;

  const CameraWrapper({
    super.key,
    required this.builder,
  });

  @override
  ConsumerState<CameraWrapper> createState() => _CameraWrapperState();
}

class _CameraWrapperState extends ConsumerState<CameraWrapper> {
  double _lastScale = 1.0;

  void _handleScaleStart(ScaleStartDetails details) {
    _lastScale = 1.0;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final controller = ref.read(cameraControllerProvider.notifier);

    // Handle rotation
    if (details.scale == 1.0) {
      controller.orbit(
        details.focalPointDelta.dx * 0.01,
        -details.focalPointDelta.dy * 0.01,
      );
    }

    // Handle zoom
    if (details.scale != 1.0) {
      final double delta = details.scale / _lastScale;
      controller.zoom(1.0 / delta); // Invert delta for natural zoom direction
      _lastScale = details.scale;
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final controller = ref.read(cameraControllerProvider.notifier);
      controller.zoom(1.0 + event.scrollDelta.dy * 0.001);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraControllerProvider);

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        child: widget.builder(cameraState),
      ),
    );
  }
}
