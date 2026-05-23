// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeRouterClientHash() =>
    r'ecbad677ebaeda5797f082f5ba940f48b223150f';

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

/// See also [activeRouterClient].
@ProviderFor(activeRouterClient)
const activeRouterClientProvider = ActiveRouterClientFamily();

/// See also [activeRouterClient].
class ActiveRouterClientFamily extends Family<RouterClient?> {
  /// See also [activeRouterClient].
  const ActiveRouterClientFamily();

  /// See also [activeRouterClient].
  ActiveRouterClientProvider call(
    String brand,
    String ip,
    String user,
    String pass,
  ) {
    return ActiveRouterClientProvider(brand, ip, user, pass);
  }

  @override
  ActiveRouterClientProvider getProviderOverride(
    covariant ActiveRouterClientProvider provider,
  ) {
    return call(provider.brand, provider.ip, provider.user, provider.pass);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activeRouterClientProvider';
}

/// See also [activeRouterClient].
class ActiveRouterClientProvider extends AutoDisposeProvider<RouterClient?> {
  /// See also [activeRouterClient].
  ActiveRouterClientProvider(String brand, String ip, String user, String pass)
    : this._internal(
        (ref) => activeRouterClient(
          ref as ActiveRouterClientRef,
          brand,
          ip,
          user,
          pass,
        ),
        from: activeRouterClientProvider,
        name: r'activeRouterClientProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeRouterClientHash,
        dependencies: ActiveRouterClientFamily._dependencies,
        allTransitiveDependencies:
            ActiveRouterClientFamily._allTransitiveDependencies,
        brand: brand,
        ip: ip,
        user: user,
        pass: pass,
      );

  ActiveRouterClientProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.brand,
    required this.ip,
    required this.user,
    required this.pass,
  }) : super.internal();

  final String brand;
  final String ip;
  final String user;
  final String pass;

  @override
  Override overrideWith(
    RouterClient? Function(ActiveRouterClientRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveRouterClientProvider._internal(
        (ref) => create(ref as ActiveRouterClientRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        brand: brand,
        ip: ip,
        user: user,
        pass: pass,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<RouterClient?> createElement() {
    return _ActiveRouterClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveRouterClientProvider &&
        other.brand == brand &&
        other.ip == ip &&
        other.user == user &&
        other.pass == pass;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, brand.hashCode);
    hash = _SystemHash.combine(hash, ip.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);
    hash = _SystemHash.combine(hash, pass.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveRouterClientRef on AutoDisposeProviderRef<RouterClient?> {
  /// The parameter `brand` of this provider.
  String get brand;

  /// The parameter `ip` of this provider.
  String get ip;

  /// The parameter `user` of this provider.
  String get user;

  /// The parameter `pass` of this provider.
  String get pass;
}

class _ActiveRouterClientProviderElement
    extends AutoDisposeProviderElement<RouterClient?>
    with ActiveRouterClientRef {
  _ActiveRouterClientProviderElement(super.provider);

  @override
  String get brand => (origin as ActiveRouterClientProvider).brand;
  @override
  String get ip => (origin as ActiveRouterClientProvider).ip;
  @override
  String get user => (origin as ActiveRouterClientProvider).user;
  @override
  String get pass => (origin as ActiveRouterClientProvider).pass;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
