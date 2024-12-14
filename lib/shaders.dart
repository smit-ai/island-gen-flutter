import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:flutter/foundation.dart';

const String _kShaderBundlePath = 'build/shaderbundles/my_renderer.shaderbundle';

gpu.ShaderLibrary? _shaderLibrary;
gpu.ShaderLibrary get shaderLibrary {
  if (_shaderLibrary != null) {
    return _shaderLibrary!;
  }

  try {
    debugPrint('Loading shader bundle from: $_kShaderBundlePath');
    _shaderLibrary = gpu.ShaderLibrary.fromAsset(_kShaderBundlePath);

    if (_shaderLibrary == null) {
      throw Exception('ShaderLibrary.fromAsset returned null');
    }

    // Verify shaders are present
    final terrainVert = _shaderLibrary!['TerrainVertex'];
    final terrainFrag = _shaderLibrary!['TerrainFragment'];
    final noiseVert = _shaderLibrary!['NoiseVertex'];
    final noiseFrag = _shaderLibrary!['NoiseFragment'];
    final blendFrag = _shaderLibrary!['BlendFragment'];

    debugPrint('Shader availability:');
    debugPrint('TerrainVertex: ${terrainVert != null}');
    debugPrint('TerrainFragment: ${terrainFrag != null}');
    debugPrint('NoiseVertex: ${noiseVert != null}');
    debugPrint('NoiseFragment: ${noiseFrag != null}');
    debugPrint('BlendFragment: ${blendFrag != null}');
    debugPrint('Successfully loaded shader bundle');
    return _shaderLibrary!;
  } catch (e) {
    debugPrint('Error loading shader bundle: $e');
    rethrow;
  }
}
