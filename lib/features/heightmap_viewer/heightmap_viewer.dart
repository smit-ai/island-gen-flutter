import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/heightmap_viewer/heightmap_painter.dart';

class HeightmapViewer extends ConsumerWidget {
  const HeightmapViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proccesedHeightmapTexture = ref.watch(heightmapDataProvider);
    final noActiveLayers = ref.watch(globalStateProvider).activeLayerStack.isEmpty;

    if (noActiveLayers) {
      return const Center(
        child: Text('No active layers'),
      );
    }

    return CustomPaint(
      painter: HeightmapPainter(heightmap: proccesedHeightmapTexture.asImage()),
      size: Size.infinite,
    );
  }
}
