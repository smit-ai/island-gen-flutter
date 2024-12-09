import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:island_gen_flutter/models/layer.dart';
import 'package:island_gen_flutter/utils/gpu_noise_generator.dart';

class HeightmapGenerator {
  static Future<List<double>> generateHeightmap(Layer layer, Size resolution) async {
    return GpuNoiseGenerator.generateHeightmap(layer, resolution);
  }

  static List<double> blendHeightmaps(List<double> base, List<double> layer, LayerBlendMode mode, double opacity) {
    final length = base.length;
    final result = List<double>.filled(length, 0.0, growable: false);

    for (var i = 0; i < length; i++) {
      final baseValue = base[i];
      final layerValue = layer[i] * opacity;

      double val;
      switch (mode) {
        case LayerBlendMode.add:
          val = baseValue + layerValue;
          break;
        case LayerBlendMode.subtract:
          val = baseValue - layerValue;
          break;
        case LayerBlendMode.min:
          val = math.min(baseValue, layerValue);
          break;
        case LayerBlendMode.max:
          val = math.max(baseValue, layerValue);
          break;
      }

      // Clamp results to [0,1]
      result[i] = val < 0.0 ? 0.0 : (val > 1.0 ? 1.0 : val);
    }

    return result;
  }
}
