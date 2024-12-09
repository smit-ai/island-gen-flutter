// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package:island_gen_flutter/features/editor/components/layers_panel/controller/layer_panel_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LayerPanelState {
  List<String> get layerIds => throw _privateConstructorUsedError;
  String? get selectedLayerId => throw _privateConstructorUsedError;

  /// Create a copy of LayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LayerPanelStateCopyWith<LayerPanelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerPanelStateCopyWith<$Res> {
  factory $LayerPanelStateCopyWith(
          LayerPanelState value, $Res Function(LayerPanelState) then) =
      _$LayerPanelStateCopyWithImpl<$Res, LayerPanelState>;
  @useResult
  $Res call({List<String> layerIds, String? selectedLayerId});
}

/// @nodoc
class _$LayerPanelStateCopyWithImpl<$Res, $Val extends LayerPanelState>
    implements $LayerPanelStateCopyWith<$Res> {
  _$LayerPanelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? layerIds = null,
    Object? selectedLayerId = freezed,
  }) {
    return _then(_value.copyWith(
      layerIds: null == layerIds
          ? _value.layerIds
          : layerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedLayerId: freezed == selectedLayerId
          ? _value.selectedLayerId
          : selectedLayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LayerPanelStateImplCopyWith<$Res>
    implements $LayerPanelStateCopyWith<$Res> {
  factory _$$LayerPanelStateImplCopyWith(_$LayerPanelStateImpl value,
          $Res Function(_$LayerPanelStateImpl) then) =
      __$$LayerPanelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> layerIds, String? selectedLayerId});
}

/// @nodoc
class __$$LayerPanelStateImplCopyWithImpl<$Res>
    extends _$LayerPanelStateCopyWithImpl<$Res, _$LayerPanelStateImpl>
    implements _$$LayerPanelStateImplCopyWith<$Res> {
  __$$LayerPanelStateImplCopyWithImpl(
      _$LayerPanelStateImpl _value, $Res Function(_$LayerPanelStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? layerIds = null,
    Object? selectedLayerId = freezed,
  }) {
    return _then(_$LayerPanelStateImpl(
      layerIds: null == layerIds
          ? _value._layerIds
          : layerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedLayerId: freezed == selectedLayerId
          ? _value.selectedLayerId
          : selectedLayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LayerPanelStateImpl implements _LayerPanelState {
  const _$LayerPanelStateImpl(
      {final List<String> layerIds = const [], this.selectedLayerId = null})
      : _layerIds = layerIds;

  final List<String> _layerIds;
  @override
  @JsonKey()
  List<String> get layerIds {
    if (_layerIds is EqualUnmodifiableListView) return _layerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layerIds);
  }

  @override
  @JsonKey()
  final String? selectedLayerId;

  @override
  String toString() {
    return 'LayerPanelState(layerIds: $layerIds, selectedLayerId: $selectedLayerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerPanelStateImpl &&
            const DeepCollectionEquality().equals(other._layerIds, _layerIds) &&
            (identical(other.selectedLayerId, selectedLayerId) ||
                other.selectedLayerId == selectedLayerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_layerIds), selectedLayerId);

  /// Create a copy of LayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerPanelStateImplCopyWith<_$LayerPanelStateImpl> get copyWith =>
      __$$LayerPanelStateImplCopyWithImpl<_$LayerPanelStateImpl>(
          this, _$identity);
}

abstract class _LayerPanelState implements LayerPanelState {
  const factory _LayerPanelState(
      {final List<String> layerIds,
      final String? selectedLayerId}) = _$LayerPanelStateImpl;

  @override
  List<String> get layerIds;
  @override
  String? get selectedLayerId;

  /// Create a copy of LayerPanelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LayerPanelStateImplCopyWith<_$LayerPanelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
