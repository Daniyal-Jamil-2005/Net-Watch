// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'behavioral_classifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$classifyDeviceBehaviorHash() =>
    r'41795172f97706a95ff791ee55f83ef3a33b7e2f';

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

/// See also [classifyDeviceBehavior].
@ProviderFor(classifyDeviceBehavior)
const classifyDeviceBehaviorProvider = ClassifyDeviceBehaviorFamily();

/// See also [classifyDeviceBehavior].
class ClassifyDeviceBehaviorFamily extends Family<String> {
  /// See also [classifyDeviceBehavior].
  const ClassifyDeviceBehaviorFamily();

  /// See also [classifyDeviceBehavior].
  ClassifyDeviceBehaviorProvider call({
    required double txRate,
    required double rxRate,
    required double pingVariance,
  }) {
    return ClassifyDeviceBehaviorProvider(
      txRate: txRate,
      rxRate: rxRate,
      pingVariance: pingVariance,
    );
  }

  @override
  ClassifyDeviceBehaviorProvider getProviderOverride(
    covariant ClassifyDeviceBehaviorProvider provider,
  ) {
    return call(
      txRate: provider.txRate,
      rxRate: provider.rxRate,
      pingVariance: provider.pingVariance,
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
  String? get name => r'classifyDeviceBehaviorProvider';
}

/// See also [classifyDeviceBehavior].
class ClassifyDeviceBehaviorProvider extends AutoDisposeProvider<String> {
  /// See also [classifyDeviceBehavior].
  ClassifyDeviceBehaviorProvider({
    required double txRate,
    required double rxRate,
    required double pingVariance,
  }) : this._internal(
         (ref) => classifyDeviceBehavior(
           ref as ClassifyDeviceBehaviorRef,
           txRate: txRate,
           rxRate: rxRate,
           pingVariance: pingVariance,
         ),
         from: classifyDeviceBehaviorProvider,
         name: r'classifyDeviceBehaviorProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$classifyDeviceBehaviorHash,
         dependencies: ClassifyDeviceBehaviorFamily._dependencies,
         allTransitiveDependencies:
             ClassifyDeviceBehaviorFamily._allTransitiveDependencies,
         txRate: txRate,
         rxRate: rxRate,
         pingVariance: pingVariance,
       );

  ClassifyDeviceBehaviorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.txRate,
    required this.rxRate,
    required this.pingVariance,
  }) : super.internal();

  final double txRate;
  final double rxRate;
  final double pingVariance;

  @override
  Override overrideWith(
    String Function(ClassifyDeviceBehaviorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClassifyDeviceBehaviorProvider._internal(
        (ref) => create(ref as ClassifyDeviceBehaviorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        txRate: txRate,
        rxRate: rxRate,
        pingVariance: pingVariance,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _ClassifyDeviceBehaviorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClassifyDeviceBehaviorProvider &&
        other.txRate == txRate &&
        other.rxRate == rxRate &&
        other.pingVariance == pingVariance;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, txRate.hashCode);
    hash = _SystemHash.combine(hash, rxRate.hashCode);
    hash = _SystemHash.combine(hash, pingVariance.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClassifyDeviceBehaviorRef on AutoDisposeProviderRef<String> {
  /// The parameter `txRate` of this provider.
  double get txRate;

  /// The parameter `rxRate` of this provider.
  double get rxRate;

  /// The parameter `pingVariance` of this provider.
  double get pingVariance;
}

class _ClassifyDeviceBehaviorProviderElement
    extends AutoDisposeProviderElement<String>
    with ClassifyDeviceBehaviorRef {
  _ClassifyDeviceBehaviorProviderElement(super.provider);

  @override
  double get txRate => (origin as ClassifyDeviceBehaviorProvider).txRate;
  @override
  double get rxRate => (origin as ClassifyDeviceBehaviorProvider).rxRate;
  @override
  double get pingVariance =>
      (origin as ClassifyDeviceBehaviorProvider).pingVariance;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
