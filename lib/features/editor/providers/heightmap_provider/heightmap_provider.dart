import 'dart:ui' as ui;
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/heightmap_provider/heightmap_provider.g.dart';

@Riverpod(keepAlive: true)
class HeightmapData extends _$HeightmapData {
  @override
  ui.Image? build() {
    final selectedLayer = ref.watch(globalStateProvider.select((value) => value.selectedLayer));
    if (selectedLayer == null) {
      return null;
    }

    return selectedLayer.cachedData;
  }
}
