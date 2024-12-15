// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$layerControllerHash() => r'af406f43b8c210cb4bab6098c428a4be2e4d5b91';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LayerController extends BuildlessNotifier<Layer> {
  late final String layerId;

  Layer build(
    String layerId,
  );
}

/// See also [LayerController].
@ProviderFor(LayerController)
const layerControllerProvider = LayerControllerFamily();

/// See also [LayerController].
class LayerControllerFamily extends Family<Layer> {
  /// See also [LayerController].
  const LayerControllerFamily();

  /// See also [LayerController].
  LayerControllerProvider call(
    String layerId,
  ) {
    return LayerControllerProvider(
      layerId,
    );
  }

  @override
  LayerControllerProvider getProviderOverride(
    covariant LayerControllerProvider provider,
  ) {
    return call(
      provider.layerId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'layerControllerProvider';
}

/// See also [LayerController].
class LayerControllerProvider
    extends NotifierProviderImpl<LayerController, Layer> {
  /// See also [LayerController].
  LayerControllerProvider(
    String layerId,
  ) : this._internal(
          () => LayerController()..layerId = layerId,
          from: layerControllerProvider,
          name: r'layerControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$layerControllerHash,
          dependencies: LayerControllerFamily._dependencies,
          allTransitiveDependencies:
              LayerControllerFamily._allTransitiveDependencies,
          layerId: layerId,
        );

  LayerControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.layerId,
  }) : super.internal();

  final String layerId;

  @override
  Layer runNotifierBuild(
    covariant LayerController notifier,
  ) {
    return notifier.build(
      layerId,
    );
  }

  @override
  Override overrideWith(LayerController Function() create) {
    return ProviderOverride(
      origin: this,
      override: LayerControllerProvider._internal(
        () => create()..layerId = layerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        layerId: layerId,
      ),
    );
  }

  @override
  NotifierProviderElement<LayerController, Layer> createElement() {
    return _LayerControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LayerControllerProvider && other.layerId == layerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, layerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LayerControllerRef on NotifierProviderRef<Layer> {
  /// The parameter `layerId` of this provider.
  String get layerId;
}

class _LayerControllerProviderElement
    extends NotifierProviderElement<LayerController, Layer>
    with LayerControllerRef {
  _LayerControllerProviderElement(super.provider);

  @override
  String get layerId => (origin as LayerControllerProvider).layerId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
