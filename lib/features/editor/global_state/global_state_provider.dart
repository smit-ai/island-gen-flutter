import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

part 'package:island_gen_flutter/generated/features/editor/global_state/global_state_provider.g.dart';
part 'package:island_gen_flutter/generated/features/editor/global_state/global_state_provider.freezed.dart';

@freezed
class GlobalStateModel with _$GlobalStateModel {
  const factory GlobalStateModel({
    @Default(false) bool isLoading,
    @Default(GlobalSettingsModel()) GlobalSettingsModel settings,
    @Default([]) List<Layer> layerStack,
    @Default([]) List<Layer> activeLayerStack,
    @Default(null) Layer? selectedLayer,
    @Default([]) List<String> isolatedLayerIds,
  }) = _GlobalStateModel;
}

@Riverpod(keepAlive: true)
class GlobalState extends _$GlobalState {
  final List<String> _layerIds = [];
  String? _selectedLayerId;
  final List<String> _isolatedLayerIds = [];

  @override
  GlobalStateModel build() {
    final globalSettings = ref.watch(globalSettingsProvider);
    final layerStack = <Layer>[];
    for (final layerId in _layerIds) {
      final layer = ref.watch(layerControllerProvider(layerId));
      layerStack.add(layer);
    }

    final selectedLayer = _selectedLayerId != null ? layerStack.firstWhereOrNull((layer) => layer.id == _selectedLayerId) : null;
    final activeLayerStack = <Layer>[];

    if (_isolatedLayerIds.isEmpty) {
      activeLayerStack.addAll(layerStack);
    } else {
      for (final layerId in _isolatedLayerIds) {
        final layer = layerStack.firstWhereOrNull((layer) => layer.id == layerId);
        if (layer != null) {
          activeLayerStack.add(layer);
        }
      }
    }

    return GlobalStateModel(
      settings: globalSettings,
      layerStack: layerStack,
      activeLayerStack: activeLayerStack,
      selectedLayer: selectedLayer,
      isolatedLayerIds: _isolatedLayerIds,
    );
  }

  void toggleIsolateLayer(String layerId) {
    if (_isolatedLayerIds.contains(layerId)) {
      _isolatedLayerIds.remove(layerId);
    } else {
      _isolatedLayerIds.add(layerId);
    }
    ref.invalidateSelf();
  }

  void selectLayer(String? layerId) {
    _selectedLayerId = layerId;
    ref.invalidateSelf();
  }

  void addLayer() {
    final layerId = Uuid().v4();
    _layerIds.add(layerId);
    _selectedLayerId = layerId;
    ref.invalidateSelf();
  }

  void removeLayer(String id) {
    _layerIds.remove(id);
    ref.invalidateSelf();
  }
}
