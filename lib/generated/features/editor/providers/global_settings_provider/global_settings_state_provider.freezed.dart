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
mixin _$Resolution {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  /// Create a copy of Resolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResolutionCopyWith<Resolution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResolutionCopyWith<$Res> {
  factory $ResolutionCopyWith(
          Resolution value, $Res Function(Resolution) then) =
      _$ResolutionCopyWithImpl<$Res, Resolution>;
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class _$ResolutionCopyWithImpl<$Res, $Val extends Resolution>
    implements $ResolutionCopyWith<$Res> {
  _$ResolutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Resolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResolutionImplCopyWith<$Res>
    implements $ResolutionCopyWith<$Res> {
  factory _$$ResolutionImplCopyWith(
          _$ResolutionImpl value, $Res Function(_$ResolutionImpl) then) =
      __$$ResolutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class __$$ResolutionImplCopyWithImpl<$Res>
    extends _$ResolutionCopyWithImpl<$Res, _$ResolutionImpl>
    implements _$$ResolutionImplCopyWith<$Res> {
  __$$ResolutionImplCopyWithImpl(
      _$ResolutionImpl _value, $Res Function(_$ResolutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Resolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$ResolutionImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ResolutionImpl implements _Resolution {
  const _$ResolutionImpl({required this.width, required this.height});

  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'Resolution(width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResolutionImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, width, height);

  /// Create a copy of Resolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResolutionImplCopyWith<_$ResolutionImpl> get copyWith =>
      __$$ResolutionImplCopyWithImpl<_$ResolutionImpl>(this, _$identity);
}

abstract class _Resolution implements Resolution {
  const factory _Resolution(
      {required final int width, required final int height}) = _$ResolutionImpl;

  @override
  int get width;
  @override
  int get height;

  /// Create a copy of Resolution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResolutionImplCopyWith<_$ResolutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GlobalSettingsModel {
  Resolution get resolution => throw _privateConstructorUsedError;
  int get seed => throw _privateConstructorUsedError;
  ViewMode get viewMode => throw _privateConstructorUsedError;
  List<Resolution> get presets => throw _privateConstructorUsedError;

  /// Create a copy of GlobalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalSettingsModelCopyWith<GlobalSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalSettingsModelCopyWith<$Res> {
  factory $GlobalSettingsModelCopyWith(
          GlobalSettingsModel value, $Res Function(GlobalSettingsModel) then) =
      _$GlobalSettingsModelCopyWithImpl<$Res, GlobalSettingsModel>;
  @useResult
  $Res call(
      {Resolution resolution,
      int seed,
      ViewMode viewMode,
      List<Resolution> presets});

  $ResolutionCopyWith<$Res> get resolution;
}

/// @nodoc
class _$GlobalSettingsModelCopyWithImpl<$Res, $Val extends GlobalSettingsModel>
    implements $GlobalSettingsModelCopyWith<$Res> {
  _$GlobalSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalSettingsModel
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
              as Resolution,
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
              as List<Resolution>,
    ) as $Val);
  }

  /// Create a copy of GlobalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResolutionCopyWith<$Res> get resolution {
    return $ResolutionCopyWith<$Res>(_value.resolution, (value) {
      return _then(_value.copyWith(resolution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GlobalSettingsModelImplCopyWith<$Res>
    implements $GlobalSettingsModelCopyWith<$Res> {
  factory _$$GlobalSettingsModelImplCopyWith(_$GlobalSettingsModelImpl value,
          $Res Function(_$GlobalSettingsModelImpl) then) =
      __$$GlobalSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Resolution resolution,
      int seed,
      ViewMode viewMode,
      List<Resolution> presets});

  @override
  $ResolutionCopyWith<$Res> get resolution;
}

/// @nodoc
class __$$GlobalSettingsModelImplCopyWithImpl<$Res>
    extends _$GlobalSettingsModelCopyWithImpl<$Res, _$GlobalSettingsModelImpl>
    implements _$$GlobalSettingsModelImplCopyWith<$Res> {
  __$$GlobalSettingsModelImplCopyWithImpl(_$GlobalSettingsModelImpl _value,
      $Res Function(_$GlobalSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resolution = null,
    Object? seed = null,
    Object? viewMode = null,
    Object? presets = null,
  }) {
    return _then(_$GlobalSettingsModelImpl(
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as Resolution,
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
              as List<Resolution>,
    ));
  }
}

/// @nodoc

class _$GlobalSettingsModelImpl implements _GlobalSettingsModel {
  const _$GlobalSettingsModelImpl(
      {this.resolution = const Resolution(width: 1024, height: 1024),
      this.seed = 0,
      this.viewMode = ViewMode.view2D,
      final List<Resolution> presets = const [
        Resolution(width: 64, height: 64),
        Resolution(width: 128, height: 128),
        Resolution(width: 256, height: 256),
        Resolution(width: 512, height: 512),
        Resolution(width: 1024, height: 1024),
        Resolution(width: 2048, height: 2048),
        Resolution(width: 4096, height: 4096)
      ]})
      : _presets = presets;

  @override
  @JsonKey()
  final Resolution resolution;
  @override
  @JsonKey()
  final int seed;
  @override
  @JsonKey()
  final ViewMode viewMode;
  final List<Resolution> _presets;
  @override
  @JsonKey()
  List<Resolution> get presets {
    if (_presets is EqualUnmodifiableListView) return _presets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presets);
  }

  @override
  String toString() {
    return 'GlobalSettingsModel(resolution: $resolution, seed: $seed, viewMode: $viewMode, presets: $presets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalSettingsModelImpl &&
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

  /// Create a copy of GlobalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalSettingsModelImplCopyWith<_$GlobalSettingsModelImpl> get copyWith =>
      __$$GlobalSettingsModelImplCopyWithImpl<_$GlobalSettingsModelImpl>(
          this, _$identity);
}

abstract class _GlobalSettingsModel implements GlobalSettingsModel {
  const factory _GlobalSettingsModel(
      {final Resolution resolution,
      final int seed,
      final ViewMode viewMode,
      final List<Resolution> presets}) = _$GlobalSettingsModelImpl;

  @override
  Resolution get resolution;
  @override
  int get seed;
  @override
  ViewMode get viewMode;
  @override
  List<Resolution> get presets;

  /// Create a copy of GlobalSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalSettingsModelImplCopyWith<_$GlobalSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
