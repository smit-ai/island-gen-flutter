import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/heightmap_generator/heightmap_generator.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/layer_provider/layer_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerController extends _$LayerController {
  LayerNoiseParams? _previousParams;

  @override
  Layer build(String layerId) {
    print('LayerController build: $layerId');
    ref.listen(globalSettingsProvider, (previous, next) {
      if (previous?.resolution != next.resolution) {
        state = initLayer(layerId);
      }
    });

    return initLayer(layerId);
  }

  Layer initLayer(String layerId) {
    final globalSettings = ref.read(globalSettingsProvider);
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      globalSettings.resolution.width.toInt(),
      globalSettings.resolution.height.toInt(),
      format: gpu.PixelFormat.r32g32b32a32Float,
    )!;

    final noiseParams = _previousParams ?? LayerNoiseParams();
    final noiseGenId = HeightmapGenerator.noise(texture, noiseParams);
    final layer = Layer.newLayer(layerId, texture, noiseGenId: noiseGenId, noiseParams: noiseParams);

    return layer;
  }

  void destroy() {
    ref.invalidateSelf();
  }

  void toggleVisibility() {
    state = state.copyWith(visible: !state.visible);
  }

  void regenerateNoiseMap() {
    final noiseGenId = HeightmapGenerator.noise(
      state.texture,
      state.noiseParams,
    );
    state = state.copyWith(noiseGenId: noiseGenId);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateInfluence(double influence) {
    state = state.copyWith(influence: influence);
  }

  void updateBlendMode(LayerBlendMode blendMode) {
    state = state.copyWith(blendMode: blendMode);
  }

  void updateNoiseParams(LayerNoiseParams noiseParams) {
    _previousParams = noiseParams;
    state = state.copyWith(noiseParams: noiseParams);
    regenerateNoiseMap();
  }
}
