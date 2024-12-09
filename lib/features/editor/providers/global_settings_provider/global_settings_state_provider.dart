import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package:island_gen_flutter/generated/features/editor/providers/global_settings_provider/global_settings_state_provider.g.dart';
part 'package:island_gen_flutter/generated/features/editor/providers/global_settings_provider/global_settings_state_provider.freezed.dart';

@freezed
class GlobalSettingsState with _$GlobalSettingsState {
  const factory GlobalSettingsState({
    @Default(Size(64, 64)) Size resolution,
    @Default(0) int seed,
    @Default([
      Size(64, 64),
      Size(128, 128),
      Size(256, 256),
      Size(512, 512),
      Size(1024, 1024),
      Size(2048, 2048),
      Size(4096, 4096),
    ])
    List<Size> presets,
  }) = _GlobalSettingsState;
}

@Riverpod(keepAlive: true)
class GlobalSettings extends _$GlobalSettings {
  @override
  GlobalSettingsState build() => const GlobalSettingsState();

  void updateResolution(Size resolution) {
    state = state.copyWith(resolution: resolution);
  }

  void updateSeed(int seed) {
    state = state.copyWith(seed: seed);
  }
}
