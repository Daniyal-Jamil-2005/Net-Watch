// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rogue_detector.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isRogueDeviceHash() => r'437f604a7d7178d3c5169a15d85a4b0418d5a776';

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

/// See also [isRogueDevice].
@ProviderFor(isRogueDevice)
const isRogueDeviceProvider = IsRogueDeviceFamily();

/// See also [isRogueDevice].
class IsRogueDeviceFamily extends Family<bool> {
  /// See also [isRogueDevice].
  const IsRogueDeviceFamily();

  /// See also [isRogueDevice].
  IsRogueDeviceProvider call(String macAddress) {
    return IsRogueDeviceProvider(macAddress);
  }

  @override
  IsRogueDeviceProvider getProviderOverride(
    covariant IsRogueDeviceProvider provider,
  ) {
    return call(provider.macAddress);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isRogueDeviceProvider';
}

/// See also [isRogueDevice].
class IsRogueDeviceProvider extends AutoDisposeProvider<bool> {
  /// See also [isRogueDevice].
  IsRogueDeviceProvider(String macAddress)
    : this._internal(
        (ref) => isRogueDevice(ref as IsRogueDeviceRef, macAddress),
        from: isRogueDeviceProvider,
        name: r'isRogueDeviceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isRogueDeviceHash,
        dependencies: IsRogueDeviceFamily._dependencies,
        allTransitiveDependencies:
            IsRogueDeviceFamily._allTransitiveDependencies,
        macAddress: macAddress,
      );

  IsRogueDeviceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.macAddress,
  }) : super.internal();

  final String macAddress;

  @override
  Override overrideWith(bool Function(IsRogueDeviceRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: IsRogueDeviceProvider._internal(
        (ref) => create(ref as IsRogueDeviceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        macAddress: macAddress,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsRogueDeviceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsRogueDeviceProvider && other.macAddress == macAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, macAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsRogueDeviceRef on AutoDisposeProviderRef<bool> {
  /// The parameter `macAddress` of this provider.
  String get macAddress;
}

class _IsRogueDeviceProviderElement extends AutoDisposeProviderElement<bool>
    with IsRogueDeviceRef {
  _IsRogueDeviceProviderElement(super.provider);

  @override
  String get macAddress => (origin as IsRogueDeviceProvider).macAddress;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
