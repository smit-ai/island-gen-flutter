import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/heightmap_viewer/heightmap_painter.dart';

class HeightmapViewer extends ConsumerWidget {
  const HeightmapViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayer = ref.watch(globalStateProvider.select((value) => value.selectedLayer));

    if (selectedLayer == null) {
      return const Center(
        child: Text('No layer selected'),
      );
    }

    if (selectedLayer.cachedData == null) {
      return const Center(
        child: Text('No heightmap data'),
      );
    }

    return CustomPaint(
      painter: HeightmapPainter(heightmap: selectedLayer.cachedData!),
      size: Size.infinite,
    );
  }
}
