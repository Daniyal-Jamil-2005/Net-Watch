// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openwrt_detector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$openwrtDetectorHash() => r'69801dfcef05e8e8c381ca6448cf0d6870ba222a';

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

/// See also [openwrtDetector].
@ProviderFor(openwrtDetector)
const openwrtDetectorProvider = OpenwrtDetectorFamily();

/// See also [openwrtDetector].
class OpenwrtDetectorFamily extends Family<AsyncValue<String>> {
  /// See also [openwrtDetector].
  const OpenwrtDetectorFamily();

  /// See also [openwrtDetector].
  OpenwrtDetectorProvider call(String ip) {
    return OpenwrtDetectorProvider(ip);
  }

  @override
  OpenwrtDetectorProvider getProviderOverride(
    covariant OpenwrtDetectorProvider provider,
  ) {
    return call(provider.ip);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'openwrtDetectorProvider';
}

/// See also [openwrtDetector].
class OpenwrtDetectorProvider extends AutoDisposeFutureProvider<String> {
  /// See also [openwrtDetector].
  OpenwrtDetectorProvider(String ip)
    : this._internal(
        (ref) => openwrtDetector(ref as OpenwrtDetectorRef, ip),
        from: openwrtDetectorProvider,
        name: r'openwrtDetectorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$openwrtDetectorHash,
        dependencies: OpenwrtDetectorFamily._dependencies,
        allTransitiveDependencies:
            OpenwrtDetectorFamily._allTransitiveDependencies,
        ip: ip,
      );

  OpenwrtDetectorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ip,
  }) : super.internal();

  final String ip;

  @override
  Override overrideWith(
    FutureOr<String> Function(OpenwrtDetectorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenwrtDetectorProvider._internal(
        (ref) => create(ref as OpenwrtDetectorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ip: ip,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _OpenwrtDetectorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenwrtDetectorProvider && other.ip == ip;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ip.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OpenwrtDetectorRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `ip` of this provider.
  String get ip;
}

class _OpenwrtDetectorProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with OpenwrtDetectorRef {
  _OpenwrtDetectorProviderElement(super.provider);

  @override
  String get ip => (origin as OpenwrtDetectorProvider).ip;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
