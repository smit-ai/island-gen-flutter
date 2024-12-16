// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package:island_gen_flutter/features/camera/camera_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CameraState {
  Vector3? get target => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  double? get theta => throw _privateConstructorUsedError;
  double? get phi => throw _privateConstructorUsedError;
  double? get fov => throw _privateConstructorUsedError;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CameraStateCopyWith<CameraState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateCopyWith<$Res> {
  factory $CameraStateCopyWith(
          CameraState value, $Res Function(CameraState) then) =
      _$CameraStateCopyWithImpl<$Res, CameraState>;
  @useResult
  $Res call(
      {Vector3? target,
      double? distance,
      double? theta,
      double? phi,
      double? fov});
}

/// @nodoc
class _$CameraStateCopyWithImpl<$Res, $Val extends CameraState>
    implements $CameraStateCopyWith<$Res> {
  _$CameraStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = freezed,
    Object? distance = freezed,
    Object? theta = freezed,
    Object? phi = freezed,
    Object? fov = freezed,
  }) {
    return _then(_value.copyWith(
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as Vector3?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      theta: freezed == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double?,
      phi: freezed == phi
          ? _value.phi
          : phi // ignore: cast_nullable_to_non_nullable
              as double?,
      fov: freezed == fov
          ? _value.fov
          : fov // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CameraStateImplCopyWith<$Res>
    implements $CameraStateCopyWith<$Res> {
  factory _$$CameraStateImplCopyWith(
          _$CameraStateImpl value, $Res Function(_$CameraStateImpl) then) =
      __$$CameraStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Vector3? target,
      double? distance,
      double? theta,
      double? phi,
      double? fov});
}

/// @nodoc
class __$$CameraStateImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$CameraStateImpl>
    implements _$$CameraStateImplCopyWith<$Res> {
  __$$CameraStateImplCopyWithImpl(
      _$CameraStateImpl _value, $Res Function(_$CameraStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = freezed,
    Object? distance = freezed,
    Object? theta = freezed,
    Object? phi = freezed,
    Object? fov = freezed,
  }) {
    return _then(_$CameraStateImpl(
      target: freezed == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as Vector3?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      theta: freezed == theta
          ? _value.theta
          : theta // ignore: cast_nullable_to_non_nullable
              as double?,
      phi: freezed == phi
          ? _value.phi
          : phi // ignore: cast_nullable_to_non_nullable
              as double?,
      fov: freezed == fov
          ? _value.fov
          : fov // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$CameraStateImpl extends _CameraState {
  _$CameraStateImpl(
      {this.target, this.distance, this.theta, this.phi, this.fov})
      : super._();

  @override
  final Vector3? target;
  @override
  final double? distance;
  @override
  final double? theta;
  @override
  final double? phi;
  @override
  final double? fov;

  @override
  String toString() {
    return 'CameraState(target: $target, distance: $distance, theta: $theta, phi: $phi, fov: $fov)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraStateImpl &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.theta, theta) || other.theta == theta) &&
            (identical(other.phi, phi) || other.phi == phi) &&
            (identical(other.fov, fov) || other.fov == fov));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, target, distance, theta, phi, fov);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      __$$CameraStateImplCopyWithImpl<_$CameraStateImpl>(this, _$identity);
}

abstract class _CameraState extends CameraState {
  factory _CameraState(
      {final Vector3? target,
      final double? distance,
      final double? theta,
      final double? phi,
      final double? fov}) = _$CameraStateImpl;
  _CameraState._() : super._();

  @override
  Vector3? get target;
  @override
  double? get distance;
  @override
  double? get theta;
  @override
  double? get phi;
  @override
  double? get fov;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
