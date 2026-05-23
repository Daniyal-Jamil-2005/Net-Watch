// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port_scanner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$openPortsHash() => r'f3d2ab78644408262db173dc63e57529edbf415b';

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

/// See also [openPorts].
@ProviderFor(openPorts)
const openPortsProvider = OpenPortsFamily();

/// See also [openPorts].
class OpenPortsFamily extends Family<AsyncValue<List<int>>> {
  /// See also [openPorts].
  const OpenPortsFamily();

  /// See also [openPorts].
  OpenPortsProvider call(String ip) {
    return OpenPortsProvider(ip);
  }

  @override
  OpenPortsProvider getProviderOverride(covariant OpenPortsProvider provider) {
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
  String? get name => r'openPortsProvider';
}

/// See also [openPorts].
class OpenPortsProvider extends AutoDisposeFutureProvider<List<int>> {
  /// See also [openPorts].
  OpenPortsProvider(String ip)
    : this._internal(
        (ref) => openPorts(ref as OpenPortsRef, ip),
        from: openPortsProvider,
        name: r'openPortsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$openPortsHash,
        dependencies: OpenPortsFamily._dependencies,
        allTransitiveDependencies: OpenPortsFamily._allTransitiveDependencies,
        ip: ip,
      );

  OpenPortsProvider._internal(
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
    FutureOr<List<int>> Function(OpenPortsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenPortsProvider._internal(
        (ref) => create(ref as OpenPortsRef),
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
  AutoDisposeFutureProviderElement<List<int>> createElement() {
    return _OpenPortsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenPortsProvider && other.ip == ip;
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
mixin OpenPortsRef on AutoDisposeFutureProviderRef<List<int>> {
  /// The parameter `ip` of this provider.
  String get ip;
}

class _OpenPortsProviderElement
    extends AutoDisposeFutureProviderElement<List<int>>
    with OpenPortsRef {
  _OpenPortsProviderElement(super.provider);

  @override
  String get ip => (origin as OpenPortsProvider).ip;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
