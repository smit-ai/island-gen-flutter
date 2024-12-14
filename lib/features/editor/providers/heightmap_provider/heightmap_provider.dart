import 'dart:ui' as ui;
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/heightmap_generator/heightmap_generator.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/heightmap_provider/heightmap_provider.g.dart';

@Riverpod(keepAlive: true)
class HeightmapData extends _$HeightmapData {
  @override
  AsyncValue<ui.Image> build() {
    ref.listen(globalStateProvider, (previous, next) {
      if (next.activeLayerStack != previous?.activeLayerStack) {
        if (next.activeLayerStack.isNotEmpty) {
          processLayerStack(next.activeLayerStack);
        } else {
          state = AsyncError(Exception('No active layer stack'), StackTrace.current);
        }
      }
    });

    return AsyncLoading();
  }

  void processLayerStack(List<Layer> layerStack) async {
    final heightmap = await HeightmapGenerator.blendLayerStack(layerStack);
    state = AsyncData(heightmap);
  }
}
