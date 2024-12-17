import 'package:flutter_gpu/gpu.dart' as gpu;

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
    @Default(8.0) double frequency,
    @Default(7) int octaves,
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
    required String name,
    required bool visible,
    required double influence,
    required LayerBlendMode blendMode,
    required LayerNoiseParams noiseParams,
    required gpu.Texture texture,
    required String noiseGenId,
  }) = _Layer;

  factory Layer.newLayer(String id, gpu.Texture texture, {String noiseGenId = '', LayerNoiseParams noiseParams = const LayerNoiseParams()}) => Layer(
        id: id,
        name: 'New Layer',
        visible: true,
        influence: 1.0,
        blendMode: LayerBlendMode.add,
        noiseParams: noiseParams,
        texture: texture,
        noiseGenId: noiseGenId,
      );
}
