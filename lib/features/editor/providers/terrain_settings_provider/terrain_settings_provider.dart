import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/terrain_settings_provider/terrain_settings_provider.freezed.dart';
part 'package:island_gen_flutter/generated/features/editor/providers/terrain_settings_provider/terrain_settings_provider.g.dart';

/// Settings model for the 3D terrain visualization
@freezed
class TerrainSettingsModel with _$TerrainSettingsModel {
  const factory TerrainSettingsModel({
    /// Number of vertices along each axis (X and Z).
    /// A value of 100 creates a 100x100 grid (10,000 vertices, 19,602 triangles).
    /// Higher values give smoother terrain but impact performance.
    @Default(100) int gridResolution,
    @Default(10.0) double width, // Terrain width in world units
    @Default(2.0) double height, // Maximum terrain height
    @Default(10.0) double depth, // Terrain depth in world units
    @Default(true) bool autoRebuild, // Whether to rebuild mesh when settings change
  }) = _TerrainSettingsModel;
}

@Riverpod(keepAlive: true)
class TerrainSettings extends _$TerrainSettings {
  @override
  TerrainSettingsModel build() => const TerrainSettingsModel();

  void setGridResolution(int resolution) {
    // Clamp between 10 (coarse) and 500 (very detailed) vertices per axis
    state = state.copyWith(gridResolution: resolution.clamp(10, 2048));
  }

  void setDimensions({double? width, double? height, double? depth}) {
    state = state.copyWith(
      width: width ?? state.width,
      height: height ?? state.height,
      depth: depth ?? state.depth,
    );
  }

  void setAutoRebuild(bool autoRebuild) {
    state = state.copyWith(autoRebuild: autoRebuild);
  }
}
