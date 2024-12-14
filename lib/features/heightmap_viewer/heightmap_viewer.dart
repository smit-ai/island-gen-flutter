import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/controller/layer_panel_controller.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';
import 'package:island_gen_flutter/features/heightmap_viewer/heightmap_painter.dart';

class HeightmapViewer extends ConsumerWidget {
  const HeightmapViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerId = ref.watch(layerPanelControllerProvider.select((value) => value.selectedLayerId));

    if (selectedLayerId == null) {
      return const Center(
        child: Text('No layer selected'),
      );
    }

    final layer = ref.watch(layerControllerProvider(selectedLayerId));

    if (layer.cachedData == null) {
      return const Center(
        child: Text('No heightmap data'),
      );
    }

    return CustomPaint(
      painter: HeightmapPainter(heightmap: layer.cachedData!),
      size: Size.infinite,
    );
  }
}
