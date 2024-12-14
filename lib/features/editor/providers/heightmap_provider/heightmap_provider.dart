import 'dart:ui' as ui;
import 'package:island_gen_flutter/features/editor/components/layers_panel/controller/layer_panel_controller.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/heightmap_provider/heightmap_provider.g.dart';

@Riverpod(keepAlive: true)
class HeightmapData extends _$HeightmapData {
  @override
  ui.Image? build() {
    final selectedLayerId = ref.watch(layerPanelControllerProvider.select((value) => value.selectedLayerId));
    if (selectedLayerId == null) {
      return null;
    }

    final layer = ref.watch(layerControllerProvider(selectedLayerId));
    return layer.cachedData;
  }
}
