import 'package:freezed_annotation/freezed_annotation.dart';

part 'package:island_gen_flutter/generated/models/layer.freezed.dart';

enum NoiseType {
  perlin,
  simplex,
  voronoi,
}

enum BlendMode {
  min,
  max,
  add,
  subtract,
}

@freezed
class NoiseParams with _$NoiseParams {
  const factory NoiseParams({
    @Default(NoiseType.perlin) NoiseType type,
    @Default(1.0) double scale,
    @Default(1.0) double frequency,
    @Default(1) int octaves,
    @Default(0.5) double persistence,
    @Default(2.0) double lacunarity,
    @Default(0.0) double offsetX,
    @Default(0.0) double offsetY,
    @Default(0.0) double rotation,
    @Default(false) bool invert,
    @Default(0.0) double clampMin,
    @Default(1.0) double clampMax,
    @Default(0) int seed,
  }) = _NoiseParams;
}

@freezed
class Layer with _$Layer {
  const factory Layer({
    required String id,
    @Default('New Layer') String name,
    @Default(true) bool visible,
    @Default(BlendMode.add) BlendMode blendMode,
    @Default(1.0) double opacity,
    @Default(NoiseParams()) NoiseParams noise,
  }) = _Layer;
}
