import 'dart:math' as math;
import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';
import 'package:island_gen_flutter/models/layer.dart';

class HeightmapGenerator {
  static List<double> generateHeightmap(Layer layer, Size resolution) {
    final stopwatch = Stopwatch()..start();

    final width = resolution.width.toInt();
    final height = resolution.height.toInt();

    // Precompute constants
    final noise = layer.noise;
    final noiseType = _getNoiseType(noise.type);

    // Directly generate the noise2D array
    // This returns a List<List<double>> of size [height][width]
    // If you are sure about domain transformations (like offset, scale),
    // adjust frequency/seed or code accordingly before calling noise2().
    final noiseStopwatch = Stopwatch()..start();
    var noise2d = noise2(
      width,
      height,
      noiseType: noiseType,
      frequency: noise.frequency,
      octaves: noise.octaves,
      lacunarity: noise.lacunarity,
      gain: noise.persistence,
      seed: noise.seed,
    );
    noiseStopwatch.stop();
    print('Noise2D generation took: ${noiseStopwatch.elapsedMilliseconds}ms');

    final heightmap = List<double>.filled(width * height, 0.0, growable: false);

    // Process values inline to avoid multiple passes
    final clampMin = noise.clampMin;
    final clampMax = noise.clampMax;
    final invert = noise.invert;

    for (var y = 0; y < height; y++) {
      final row = noise2d[y];
      for (var x = 0; x < width; x++) {
        // Value is initially in [-1, 1], normalize to [0, 1]
        var value = (row[x] + 1.0) * 0.5;

        if (invert) {
          value = 1.0 - value;
        }

        // Apply clamp
        if (value < clampMin) value = clampMin;
        if (value > clampMax) value = clampMax;

        heightmap[y * width + x] = value;
      }
    }

    stopwatch.stop();
    print('Heightmap generation took: ${stopwatch.elapsedMilliseconds}ms');

    return heightmap;
  }

  static NoiseType _getNoiseType(LayerNoiseType type) {
    switch (type) {
      case LayerNoiseType.perlin:
        return NoiseType.perlinFractal;
      case LayerNoiseType.simplex:
        return NoiseType.simplexFractal;
      case LayerNoiseType.voronoi:
        return NoiseType.cellular;
    }
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
