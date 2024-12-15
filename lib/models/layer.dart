import 'dart:ui' as ui;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'package:island_gen_flutter/generated/models/layer.freezed.dart';

enum LayerNoiseType {
  perlin,
  simplex,
  voronoi,
}

enum LayerBlendMode {
  min,
  max,
  add,
  subtract,
}

@freezed
class LayerNoiseParams with _$LayerNoiseParams {
  const factory LayerNoiseParams({
    @Default(LayerNoiseType.perlin) LayerNoiseType type,
    @Default(1.0) double scale,
    @Default(1.0) double frequency,
    @Default(4) int octaves,
    @Default(0.5) double persistence,
    @Default(2.0) double lacunarity,
    @Default(0.0) double offsetX,
    @Default(0.0) double offsetY,
    @Default(0.0) double rotation,
    @Default(false) bool invert,
    @Default(0.0) double clampMin,
    @Default(1.0) double clampMax,
    @Default(0) int seed,
  }) = _LayerNoiseParams;
}

@freezed
class Layer with _$Layer {
  const factory Layer({
    required String id,
    @Default('New Layer') String name,
    @Default(true) bool visible,
    @Default(1.0) double influence,
    @Default(LayerBlendMode.add) LayerBlendMode blendMode,
    @Default(LayerNoiseParams()) LayerNoiseParams noise,
    @Default(null) ui.Image? cachedData,
  }) = _Layer;
}
