// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package:island_gen_flutter/features/editor/providers/terrain_settings_provider/terrain_settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TerrainSettingsModel {
  /// Number of vertices along each axis (X and Z).
  /// A value of 100 creates a 100x100 grid (10,000 vertices, 19,602 triangles).
  /// Higher values give smoother terrain but impact performance.
  int get gridResolution => throw _privateConstructorUsedError;
  double get width =>
      throw _privateConstructorUsedError; // Terrain width in world units
  double get height =>
      throw _privateConstructorUsedError; // Maximum terrain height
  double get depth =>
      throw _privateConstructorUsedError; // Terrain depth in world units
  bool get autoRebuild => throw _privateConstructorUsedError;

  /// Create a copy of TerrainSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TerrainSettingsModelCopyWith<TerrainSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TerrainSettingsModelCopyWith<$Res> {
  factory $TerrainSettingsModelCopyWith(TerrainSettingsModel value,
          $Res Function(TerrainSettingsModel) then) =
      _$TerrainSettingsModelCopyWithImpl<$Res, TerrainSettingsModel>;
  @useResult
  $Res call(
      {int gridResolution,
      double width,
      double height,
      double depth,
      bool autoRebuild});
}

/// @nodoc
class _$TerrainSettingsModelCopyWithImpl<$Res,
        $Val extends TerrainSettingsModel>
    implements $TerrainSettingsModelCopyWith<$Res> {
  _$TerrainSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TerrainSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gridResolution = null,
    Object? width = null,
    Object? height = null,
    Object? depth = null,
    Object? autoRebuild = null,
  }) {
    return _then(_value.copyWith(
      gridResolution: null == gridResolution
          ? _value.gridResolution
          : gridResolution // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      autoRebuild: null == autoRebuild
          ? _value.autoRebuild
          : autoRebuild // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TerrainSettingsModelImplCopyWith<$Res>
    implements $TerrainSettingsModelCopyWith<$Res> {
  factory _$$TerrainSettingsModelImplCopyWith(_$TerrainSettingsModelImpl value,
          $Res Function(_$TerrainSettingsModelImpl) then) =
      __$$TerrainSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int gridResolution,
      double width,
      double height,
      double depth,
      bool autoRebuild});
}

/// @nodoc
class __$$TerrainSettingsModelImplCopyWithImpl<$Res>
    extends _$TerrainSettingsModelCopyWithImpl<$Res, _$TerrainSettingsModelImpl>
    implements _$$TerrainSettingsModelImplCopyWith<$Res> {
  __$$TerrainSettingsModelImplCopyWithImpl(_$TerrainSettingsModelImpl _value,
      $Res Function(_$TerrainSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TerrainSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gridResolution = null,
    Object? width = null,
    Object? height = null,
    Object? depth = null,
    Object? autoRebuild = null,
  }) {
    return _then(_$TerrainSettingsModelImpl(
      gridResolution: null == gridResolution
          ? _value.gridResolution
          : gridResolution // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double,
      autoRebuild: null == autoRebuild
          ? _value.autoRebuild
          : autoRebuild // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TerrainSettingsModelImpl implements _TerrainSettingsModel {
  const _$TerrainSettingsModelImpl(
      {this.gridResolution = 100,
      this.width = 10.0,
      this.height = 2.0,
      this.depth = 10.0,
      this.autoRebuild = true});

  /// Number of vertices along each axis (X and Z).
  /// A value of 100 creates a 100x100 grid (10,000 vertices, 19,602 triangles).
  /// Higher values give smoother terrain but impact performance.
  @override
  @JsonKey()
  final int gridResolution;
  @override
  @JsonKey()
  final double width;
// Terrain width in world units
  @override
  @JsonKey()
  final double height;
// Maximum terrain height
  @override
  @JsonKey()
  final double depth;
// Terrain depth in world units
  @override
  @JsonKey()
  final bool autoRebuild;

  @override
  String toString() {
    return 'TerrainSettingsModel(gridResolution: $gridResolution, width: $width, height: $height, depth: $depth, autoRebuild: $autoRebuild)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TerrainSettingsModelImpl &&
            (identical(other.gridResolution, gridResolution) ||
                other.gridResolution == gridResolution) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.autoRebuild, autoRebuild) ||
                other.autoRebuild == autoRebuild));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, gridResolution, width, height, depth, autoRebuild);

  /// Create a copy of TerrainSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TerrainSettingsModelImplCopyWith<_$TerrainSettingsModelImpl>
      get copyWith =>
          __$$TerrainSettingsModelImplCopyWithImpl<_$TerrainSettingsModelImpl>(
              this, _$identity);
}

abstract class _TerrainSettingsModel implements TerrainSettingsModel {
  const factory _TerrainSettingsModel(
      {final int gridResolution,
      final double width,
      final double height,
      final double depth,
      final bool autoRebuild}) = _$TerrainSettingsModelImpl;

  /// Number of vertices along each axis (X and Z).
  /// A value of 100 creates a 100x100 grid (10,000 vertices, 19,602 triangles).
  /// Higher values give smoother terrain but impact performance.
  @override
  int get gridResolution;
  @override
  double get width; // Terrain width in world units
  @override
  double get height; // Maximum terrain height
  @override
  double get depth; // Terrain depth in world units
  @override
  bool get autoRebuild;

  /// Create a copy of TerrainSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TerrainSettingsModelImplCopyWith<_$TerrainSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
