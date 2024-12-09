import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'package:island_gen_flutter/generated/features/editor/components/layers_panel/controller/layer_panel_controller.g.dart';
part 'package:island_gen_flutter/generated/features/editor/components/layers_panel/controller/layer_panel_controller.freezed.dart';

@freezed
class LayerPanelState with _$LayerPanelState {
  const factory LayerPanelState({
    @Default([]) List<String> layerIds,
    @Default(null) String? selectedLayerId,
  }) = _LayerPanelState;
}

@Riverpod(keepAlive: true)
class LayerPanelController extends _$LayerPanelController {
  final _uuid = const Uuid();

  @override
  LayerPanelState build() => const LayerPanelState();

  void addLayer() {
    final layerName = 'Layer ${state.layerIds.length + 1}';
    final layerId = _uuid.v4();
    final newLayer = ref.read(layerControllerProvider(layerId).notifier);
    newLayer.updateLayerName(layerName);
    state = state.copyWith(
      layerIds: [...state.layerIds, layerId],
    );
  }

  void removeLayer(String id) {
    if (state.selectedLayerId == id) {
      state = state.copyWith(
        selectedLayerId: null,
      );
    }
    state = state.copyWith(
      layerIds: state.layerIds.where((layerId) => layerId != id).toList(),
    );
  }

  void selectLayer(String id) {
    state = state.copyWith(selectedLayerId: id);
  }
}
