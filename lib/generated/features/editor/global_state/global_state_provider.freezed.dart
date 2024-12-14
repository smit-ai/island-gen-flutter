// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GlobalStateModel {
  bool get isLoading => throw _privateConstructorUsedError;
  GlobalSettingsModel get settings => throw _privateConstructorUsedError;
  List<Layer> get layerStack => throw _privateConstructorUsedError;
  List<Layer> get activeLayerStack => throw _privateConstructorUsedError;
  Layer? get selectedLayer => throw _privateConstructorUsedError;

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalStateModelCopyWith<GlobalStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalStateModelCopyWith<$Res> {
  factory $GlobalStateModelCopyWith(
          GlobalStateModel value, $Res Function(GlobalStateModel) then) =
      _$GlobalStateModelCopyWithImpl<$Res, GlobalStateModel>;
  @useResult
  $Res call(
      {bool isLoading,
      GlobalSettingsModel settings,
      List<Layer> layerStack,
      List<Layer> activeLayerStack,
      Layer? selectedLayer});

  $GlobalSettingsModelCopyWith<$Res> get settings;
  $LayerCopyWith<$Res>? get selectedLayer;
}

/// @nodoc
class _$GlobalStateModelCopyWithImpl<$Res, $Val extends GlobalStateModel>
    implements $GlobalStateModelCopyWith<$Res> {
  _$GlobalStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? settings = null,
    Object? layerStack = null,
    Object? activeLayerStack = null,
    Object? selectedLayer = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GlobalSettingsModel,
      layerStack: null == layerStack
          ? _value.layerStack
          : layerStack // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      activeLayerStack: null == activeLayerStack
          ? _value.activeLayerStack
          : activeLayerStack // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      selectedLayer: freezed == selectedLayer
          ? _value.selectedLayer
          : selectedLayer // ignore: cast_nullable_to_non_nullable
              as Layer?,
    ) as $Val);
  }

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GlobalSettingsModelCopyWith<$Res> get settings {
    return $GlobalSettingsModelCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LayerCopyWith<$Res>? get selectedLayer {
    if (_value.selectedLayer == null) {
      return null;
    }

    return $LayerCopyWith<$Res>(_value.selectedLayer!, (value) {
      return _then(_value.copyWith(selectedLayer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GlobalStateModelImplCopyWith<$Res>
    implements $GlobalStateModelCopyWith<$Res> {
  factory _$$GlobalStateModelImplCopyWith(_$GlobalStateModelImpl value,
          $Res Function(_$GlobalStateModelImpl) then) =
      __$$GlobalStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      GlobalSettingsModel settings,
      List<Layer> layerStack,
      List<Layer> activeLayerStack,
      Layer? selectedLayer});

  @override
  $GlobalSettingsModelCopyWith<$Res> get settings;
  @override
  $LayerCopyWith<$Res>? get selectedLayer;
}

/// @nodoc
class __$$GlobalStateModelImplCopyWithImpl<$Res>
    extends _$GlobalStateModelCopyWithImpl<$Res, _$GlobalStateModelImpl>
    implements _$$GlobalStateModelImplCopyWith<$Res> {
  __$$GlobalStateModelImplCopyWithImpl(_$GlobalStateModelImpl _value,
      $Res Function(_$GlobalStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? settings = null,
    Object? layerStack = null,
    Object? activeLayerStack = null,
    Object? selectedLayer = freezed,
  }) {
    return _then(_$GlobalStateModelImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GlobalSettingsModel,
      layerStack: null == layerStack
          ? _value._layerStack
          : layerStack // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      activeLayerStack: null == activeLayerStack
          ? _value._activeLayerStack
          : activeLayerStack // ignore: cast_nullable_to_non_nullable
              as List<Layer>,
      selectedLayer: freezed == selectedLayer
          ? _value.selectedLayer
          : selectedLayer // ignore: cast_nullable_to_non_nullable
              as Layer?,
    ));
  }
}

/// @nodoc

class _$GlobalStateModelImpl implements _GlobalStateModel {
  const _$GlobalStateModelImpl(
      {this.isLoading = false,
      this.settings = const GlobalSettingsModel(),
      final List<Layer> layerStack = const [],
      final List<Layer> activeLayerStack = const [],
      this.selectedLayer = null})
      : _layerStack = layerStack,
        _activeLayerStack = activeLayerStack;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final GlobalSettingsModel settings;
  final List<Layer> _layerStack;
  @override
  @JsonKey()
  List<Layer> get layerStack {
    if (_layerStack is EqualUnmodifiableListView) return _layerStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_layerStack);
  }

  final List<Layer> _activeLayerStack;
  @override
  @JsonKey()
  List<Layer> get activeLayerStack {
    if (_activeLayerStack is EqualUnmodifiableListView)
      return _activeLayerStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeLayerStack);
  }

  @override
  @JsonKey()
  final Layer? selectedLayer;

  @override
  String toString() {
    return 'GlobalStateModel(isLoading: $isLoading, settings: $settings, layerStack: $layerStack, activeLayerStack: $activeLayerStack, selectedLayer: $selectedLayer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalStateModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality()
                .equals(other._layerStack, _layerStack) &&
            const DeepCollectionEquality()
                .equals(other._activeLayerStack, _activeLayerStack) &&
            (identical(other.selectedLayer, selectedLayer) ||
                other.selectedLayer == selectedLayer));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      settings,
      const DeepCollectionEquality().hash(_layerStack),
      const DeepCollectionEquality().hash(_activeLayerStack),
      selectedLayer);

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalStateModelImplCopyWith<_$GlobalStateModelImpl> get copyWith =>
      __$$GlobalStateModelImplCopyWithImpl<_$GlobalStateModelImpl>(
          this, _$identity);
}

abstract class _GlobalStateModel implements GlobalStateModel {
  const factory _GlobalStateModel(
      {final bool isLoading,
      final GlobalSettingsModel settings,
      final List<Layer> layerStack,
      final List<Layer> activeLayerStack,
      final Layer? selectedLayer}) = _$GlobalStateModelImpl;

  @override
  bool get isLoading;
  @override
  GlobalSettingsModel get settings;
  @override
  List<Layer> get layerStack;
  @override
  List<Layer> get activeLayerStack;
  @override
  Layer? get selectedLayer;

  /// Create a copy of GlobalStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalStateModelImplCopyWith<_$GlobalStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
