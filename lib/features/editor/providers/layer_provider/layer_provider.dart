import 'package:island_gen_flutter/models/layer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/layer_provider/layer_provider.g.dart';

@Riverpod(keepAlive: true)
class LayerController extends _$LayerController {
  @override
  Layer build(String layerId) => Layer(id: layerId);

  void destroy() {
    ref.invalidateSelf();
  }

  void generateHeightmap() {}

  void updateLayerName(String name) {
    state = state.copyWith(name: name);
  }

  void updateVisibility(bool visible) {
    state = state.copyWith(visible: visible);
  }

  void updateBlendMode(BlendMode blendMode) {
    state = state.copyWith(blendMode: blendMode);
  }

  void updateOpacity(double opacity) {
    state = state.copyWith(opacity: opacity.clamp(0.0, 1.0));
  }

  void updateNoiseType(NoiseType type) {
    state = state.copyWith(
      noise: state.noise.copyWith(type: type),
    );
  }

  void updateNoiseScale(double scale) {
    state = state.copyWith(
      noise: state.noise.copyWith(scale: scale),
    );
  }

  void updateNoiseFrequency(double frequency) {
    state = state.copyWith(
      noise: state.noise.copyWith(frequency: frequency),
    );
  }

  void updateNoiseOctaves(int octaves) {
    state = state.copyWith(
      noise: state.noise.copyWith(octaves: octaves),
    );
  }

  void updateNoisePersistence(double persistence) {
    state = state.copyWith(
      noise: state.noise.copyWith(persistence: persistence),
    );
  }

  void updateNoiseLacunarity(double lacunarity) {
    state = state.copyWith(
      noise: state.noise.copyWith(lacunarity: lacunarity),
    );
  }

  void updateNoiseOffset(double x, double y) {
    state = state.copyWith(
      noise: state.noise.copyWith(
        offsetX: x,
        offsetY: y,
      ),
    );
  }

  void updateNoiseRotation(double rotation) {
    state = state.copyWith(
      noise: state.noise.copyWith(rotation: rotation),
    );
  }

  void updateNoiseInvert(bool invert) {
    state = state.copyWith(
      noise: state.noise.copyWith(invert: invert),
    );
  }

  void updateNoiseClamp(double min, double max) {
    state = state.copyWith(
      noise: state.noise.copyWith(
        clampMin: min,
        clampMax: max,
      ),
    );
  }

  void updateNoiseSeed(int seed) {
    state = state.copyWith(
      noise: state.noise.copyWith(seed: seed),
    );
  }

  // Convenience method to update multiple noise parameters at once
  void updateNoiseParams(NoiseParams params) {
    state = state.copyWith(noise: params);
  }
}
