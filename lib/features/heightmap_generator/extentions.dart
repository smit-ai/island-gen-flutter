import 'dart:ui' as ui;
import 'package:flutter_gpu/gpu.dart' as gpu;

extension TextureExtensions on gpu.Texture {
  /// Creates a texture from a [ui.Image] with shader read usage enabled.
  static Future<gpu.Texture> fromImage(ui.Image image, gpu.PixelFormat format) async {
    // Extract ByteData in RGBA format
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawExtendedRgba128);
    if (byteData == null) {
      throw Exception('Failed to extract ByteData from image');
    }

    // Create a texture with host-visible storage for overwriting data
    final texture = gpu.gpuContext.createTexture(
      gpu.StorageMode.hostVisible, // Allows overwriting the texture data
      image.width,
      image.height,
      format: format, // Ensure the format matches the ByteData format
      enableShaderReadUsage: true, // Allows the texture to be read in shaders
    );

    // Overwrite the texture with the image's pixel data
    texture!.overwrite(byteData);

    return texture;
  }
}
