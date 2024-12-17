import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/global_settings_provider/global_settings_state_provider.g.dart';
part 'package:island_gen_flutter/generated/features/editor/providers/global_settings_provider/global_settings_state_provider.freezed.dart';

enum ViewMode {
  view2D,
  solid3D,
  wireframe3D,
  color3D,
  raymarched3D,
}

@freezed
class Resolution with _$Resolution {
  const factory Resolution({
    required int width,
    required int height,
  }) = _Resolution;
}

@freezed
class GlobalSettingsModel with _$GlobalSettingsModel {
  const factory GlobalSettingsModel({
    @Default(Resolution(width: 1024, height: 1024)) Resolution resolution,
    @Default(0) int seed,
    @Default(ViewMode.view2D) ViewMode viewMode,
    @Default([
      Resolution(width: 64, height: 64),
      Resolution(width: 128, height: 128),
      Resolution(width: 256, height: 256),
      Resolution(width: 512, height: 512),
      Resolution(width: 1024, height: 1024),
      Resolution(width: 2048, height: 2048),
      Resolution(width: 4096, height: 4096),
    ])
    List<Resolution> presets,
  }) = _GlobalSettingsModel;
}

@Riverpod(keepAlive: true)
class GlobalSettings extends _$GlobalSettings {
  @override
  GlobalSettingsModel build() => const GlobalSettingsModel();

  void updateResolution(Resolution resolution) {
    state = state.copyWith(resolution: resolution);
  }

  void updateViewMode(ViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }
}
