import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/heightmap_provider/heightmap_provider.dart';
import 'package:island_gen_flutter/features/heightmap_viewer/heightmap_painter.dart';

class HeightmapViewer extends ConsumerWidget {
  const HeightmapViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightmap = ref.watch(heightmapDataProvider);
    if (heightmap.hasError) {
      return const Center(
        child: Text('No heightmap data'),
      );
    }

    if (heightmap.isLoading) {
      return const Center(
        child: Text('Loading heightmap...'),
      );
    }

    return CustomPaint(
      painter: HeightmapPainter(heightmap: heightmap.requireValue),
      size: Size.infinite,
    );
  }
}
