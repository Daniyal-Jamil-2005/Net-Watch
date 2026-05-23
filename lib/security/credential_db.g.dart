// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_db.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkDefaultCredsHash() => r'f979bc970262a48de05ded7f4d964ebb50ac0a0f';

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

/// See also [checkDefaultCreds].
@ProviderFor(checkDefaultCreds)
const checkDefaultCredsProvider = CheckDefaultCredsFamily();

/// See also [checkDefaultCreds].
class CheckDefaultCredsFamily extends Family<AsyncValue<Map<String, String>?>> {
  /// See also [checkDefaultCreds].
  const CheckDefaultCredsFamily();

  /// See also [checkDefaultCreds].
  CheckDefaultCredsProvider call(String ip) {
    return CheckDefaultCredsProvider(ip);
  }

  @override
  CheckDefaultCredsProvider getProviderOverride(
    covariant CheckDefaultCredsProvider provider,
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
  String? get name => r'checkDefaultCredsProvider';
}

/// See also [checkDefaultCreds].
class CheckDefaultCredsProvider
    extends AutoDisposeFutureProvider<Map<String, String>?> {
  /// See also [checkDefaultCreds].
  CheckDefaultCredsProvider(String ip)
    : this._internal(
        (ref) => checkDefaultCreds(ref as CheckDefaultCredsRef, ip),
        from: checkDefaultCredsProvider,
        name: r'checkDefaultCredsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$checkDefaultCredsHash,
        dependencies: CheckDefaultCredsFamily._dependencies,
        allTransitiveDependencies:
            CheckDefaultCredsFamily._allTransitiveDependencies,
        ip: ip,
      );

  CheckDefaultCredsProvider._internal(
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
    FutureOr<Map<String, String>?> Function(CheckDefaultCredsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckDefaultCredsProvider._internal(
        (ref) => create(ref as CheckDefaultCredsRef),
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
  AutoDisposeFutureProviderElement<Map<String, String>?> createElement() {
    return _CheckDefaultCredsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckDefaultCredsProvider && other.ip == ip;
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
mixin CheckDefaultCredsRef
    on AutoDisposeFutureProviderRef<Map<String, String>?> {
  /// The parameter `ip` of this provider.
  String get ip;
}

class _CheckDefaultCredsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, String>?>
    with CheckDefaultCredsRef {
  _CheckDefaultCredsProviderElement(super.provider);

  @override
  String get ip => (origin as CheckDefaultCredsProvider).ip;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
