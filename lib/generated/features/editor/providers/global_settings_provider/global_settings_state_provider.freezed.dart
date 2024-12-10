// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GlobalSettingsState {
  Size get resolution => throw _privateConstructorUsedError;
  int get seed => throw _privateConstructorUsedError;
  ViewMode get viewMode => throw _privateConstructorUsedError;
  List<Size> get presets => throw _privateConstructorUsedError;

  /// Create a copy of GlobalSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalSettingsStateCopyWith<GlobalSettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalSettingsStateCopyWith<$Res> {
  factory $GlobalSettingsStateCopyWith(
          GlobalSettingsState value, $Res Function(GlobalSettingsState) then) =
      _$GlobalSettingsStateCopyWithImpl<$Res, GlobalSettingsState>;
  @useResult
  $Res call({Size resolution, int seed, ViewMode viewMode, List<Size> presets});
}

/// @nodoc
class _$GlobalSettingsStateCopyWithImpl<$Res, $Val extends GlobalSettingsState>
    implements $GlobalSettingsStateCopyWith<$Res> {
  _$GlobalSettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resolution = null,
    Object? seed = null,
    Object? viewMode = null,
    Object? presets = null,
  }) {
    return _then(_value.copyWith(
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as Size,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ViewMode,
      presets: null == presets
          ? _value.presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<Size>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalSettingsStateImplCopyWith<$Res>
    implements $GlobalSettingsStateCopyWith<$Res> {
  factory _$$GlobalSettingsStateImplCopyWith(_$GlobalSettingsStateImpl value,
          $Res Function(_$GlobalSettingsStateImpl) then) =
      __$$GlobalSettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Size resolution, int seed, ViewMode viewMode, List<Size> presets});
}

/// @nodoc
class __$$GlobalSettingsStateImplCopyWithImpl<$Res>
    extends _$GlobalSettingsStateCopyWithImpl<$Res, _$GlobalSettingsStateImpl>
    implements _$$GlobalSettingsStateImplCopyWith<$Res> {
  __$$GlobalSettingsStateImplCopyWithImpl(_$GlobalSettingsStateImpl _value,
      $Res Function(_$GlobalSettingsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resolution = null,
    Object? seed = null,
    Object? viewMode = null,
    Object? presets = null,
  }) {
    return _then(_$GlobalSettingsStateImpl(
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as Size,
      seed: null == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ViewMode,
      presets: null == presets
          ? _value._presets
          : presets // ignore: cast_nullable_to_non_nullable
              as List<Size>,
    ));
  }
}

/// @nodoc

class _$GlobalSettingsStateImpl implements _GlobalSettingsState {
  const _$GlobalSettingsStateImpl(
      {this.resolution = const Size(64, 64),
      this.seed = 0,
      this.viewMode = ViewMode.view2D,
      final List<Size> presets = const [
        Size(64, 64),
        Size(128, 128),
        Size(256, 256),
        Size(512, 512),
        Size(1024, 1024),
        Size(2048, 2048),
        Size(4096, 4096)
      ]})
      : _presets = presets;

  @override
  @JsonKey()
  final Size resolution;
  @override
  @JsonKey()
  final int seed;
  @override
  @JsonKey()
  final ViewMode viewMode;
  final List<Size> _presets;
  @override
  @JsonKey()
  List<Size> get presets {
    if (_presets is EqualUnmodifiableListView) return _presets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presets);
  }

  @override
  String toString() {
    return 'GlobalSettingsState(resolution: $resolution, seed: $seed, viewMode: $viewMode, presets: $presets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalSettingsStateImpl &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            const DeepCollectionEquality().equals(other._presets, _presets));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resolution, seed, viewMode,
      const DeepCollectionEquality().hash(_presets));

  /// Create a copy of GlobalSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalSettingsStateImplCopyWith<_$GlobalSettingsStateImpl> get copyWith =>
      __$$GlobalSettingsStateImplCopyWithImpl<_$GlobalSettingsStateImpl>(
          this, _$identity);
}

abstract class _GlobalSettingsState implements GlobalSettingsState {
  const factory _GlobalSettingsState(
      {final Size resolution,
      final int seed,
      final ViewMode viewMode,
      final List<Size> presets}) = _$GlobalSettingsStateImpl;

  @override
  Size get resolution;
  @override
  int get seed;
  @override
  ViewMode get viewMode;
  @override
  List<Size> get presets;

  /// Create a copy of GlobalSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalSettingsStateImplCopyWith<_$GlobalSettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
