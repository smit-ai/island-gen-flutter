import 'dart:async';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:island_gen_flutter/utils/hightmap_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/layer_provider/layer_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerController extends _$LayerController {
  Timer? _debounceTimer;

  @override
  Layer build(String layerId) {
    ref.listen(globalSettingsProvider, (previous, next) {
      if (previous?.resolution != next.resolution) {
        generateHeightmap();
      }
    });

    final resolution = ref.read(globalSettingsProvider).resolution;
    final layer = Layer(id: layerId);
    final heightmap = HeightmapGenerator.generateHeightmap(layer, resolution);
    return layer.copyWith(cachedData: heightmap);
  }

  void destroy() {
    _debounceTimer?.cancel();
    ref.invalidateSelf();
  }

  void generateHeightmap() {
    final resolution = ref.read(globalSettingsProvider).resolution;
    final heightmap = HeightmapGenerator.generateHeightmap(state, resolution);
    state = state.copyWith(cachedData: heightmap);
  }

  void _debouncedGenerateHeightmap() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), generateHeightmap);
  }

  void updateLayerName(String name) {
    state = state.copyWith(name: name);
  }

  void updateVisibility(bool visible) {
    state = state.copyWith(visible: visible);
  }

  void updateBlendMode(LayerBlendMode blendMode) {
    state = state.copyWith(blendMode: blendMode);
  }

  void updateOpacity(double opacity) {
    state = state.copyWith(opacity: opacity.clamp(0.0, 1.0));
  }

  void updateNoiseType(LayerNoiseType type) {
    state = state.copyWith(
      noise: state.noise.copyWith(type: type),
    );
    _debouncedGenerateHeightmap();
  }

  void updateNoiseScale(double scale) {
    state = state.copyWith(
      noise: state.noise.copyWith(scale: scale),
    );
    _debouncedGenerateHeightmap();
  }

  void updateNoiseFrequency(double frequency) {
    state = state.copyWith(
      noise: state.noise.copyWith(frequency: frequency),
    );
    _debouncedGenerateHeightmap();
  }

  void updateNoiseOctaves(int octaves) {
    state = state.copyWith(
      noise: state.noise.copyWith(octaves: octaves),
    );
    _debouncedGenerateHeightmap();
  }

  void updateNoisePersistence(double persistence) {
    state = state.copyWith(
      noise: state.noise.copyWith(persistence: persistence),
    );
    _debouncedGenerateHeightmap();
  }

  void updateNoiseLacunarity(double lacunarity) {
    state = state.copyWith(noise: state.noise.copyWith(lacunarity: lacunarity));
    _debouncedGenerateHeightmap();
  }

  void updateNoiseOffset(double x, double y) {
    state = state.copyWith(noise: state.noise.copyWith(offsetX: x, offsetY: y));
    _debouncedGenerateHeightmap();
  }

  void updateNoiseRotation(double rotation) {
    state = state.copyWith(noise: state.noise.copyWith(rotation: rotation));
    _debouncedGenerateHeightmap();
  }

  void updateNoiseInvert(bool invert) {
    state = state.copyWith(noise: state.noise.copyWith(invert: invert));
    _debouncedGenerateHeightmap();
  }

  void updateNoiseClamp(double min, double max) {
    state = state.copyWith(noise: state.noise.copyWith(clampMin: min, clampMax: max));
    _debouncedGenerateHeightmap();
  }

  void updateNoiseSeed(int seed) {
    state = state.copyWith(noise: state.noise.copyWith(seed: seed));
    _debouncedGenerateHeightmap();
  }

  // Convenience method to update multiple noise parameters at once
  void updateNoiseParams(LayerNoiseParams params) {
    state = state.copyWith(noise: params);
    _debouncedGenerateHeightmap();
  }
}
