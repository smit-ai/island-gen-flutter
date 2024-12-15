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

    debugPrint('Shader availability:');
    for (final shaderName in _shaderLibrary!.shaders_.keys) {
      final shader = _shaderLibrary![shaderName];
      debugPrint('$shaderName: ${shader != null}');
    }

    debugPrint('Successfully loaded shader bundle');
    return _shaderLibrary!;
  } catch (e) {
    debugPrint('Error loading shader bundle: $e');
    rethrow;
  }
}
