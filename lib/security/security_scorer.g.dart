// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_scorer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deviceSecurityScoreHash() =>
    r'4e6dc1ddd9905d0cd759e13f52fd08227a72bd0f';

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

/// See also [deviceSecurityScore].
@ProviderFor(deviceSecurityScore)
const deviceSecurityScoreProvider = DeviceSecurityScoreFamily();

/// See also [deviceSecurityScore].
class DeviceSecurityScoreFamily extends Family<int> {
  /// See also [deviceSecurityScore].
  const DeviceSecurityScoreFamily();

  /// See also [deviceSecurityScore].
  DeviceSecurityScoreProvider call({
    required List<int> openPorts,
    required bool hasDefaultCreds,
    required bool isUnknownDevice,
    required bool hasHostname,
  }) {
    return DeviceSecurityScoreProvider(
      openPorts: openPorts,
      hasDefaultCreds: hasDefaultCreds,
      isUnknownDevice: isUnknownDevice,
      hasHostname: hasHostname,
    );
  }

  @override
  DeviceSecurityScoreProvider getProviderOverride(
    covariant DeviceSecurityScoreProvider provider,
  ) {
    return call(
      openPorts: provider.openPorts,
      hasDefaultCreds: provider.hasDefaultCreds,
      isUnknownDevice: provider.isUnknownDevice,
      hasHostname: provider.hasHostname,
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
  String? get name => r'deviceSecurityScoreProvider';
}

/// See also [deviceSecurityScore].
class DeviceSecurityScoreProvider extends AutoDisposeProvider<int> {
  /// See also [deviceSecurityScore].
  DeviceSecurityScoreProvider({
    required List<int> openPorts,
    required bool hasDefaultCreds,
    required bool isUnknownDevice,
    required bool hasHostname,
  }) : this._internal(
         (ref) => deviceSecurityScore(
           ref as DeviceSecurityScoreRef,
           openPorts: openPorts,
           hasDefaultCreds: hasDefaultCreds,
           isUnknownDevice: isUnknownDevice,
           hasHostname: hasHostname,
         ),
         from: deviceSecurityScoreProvider,
         name: r'deviceSecurityScoreProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$deviceSecurityScoreHash,
         dependencies: DeviceSecurityScoreFamily._dependencies,
         allTransitiveDependencies:
             DeviceSecurityScoreFamily._allTransitiveDependencies,
         openPorts: openPorts,
         hasDefaultCreds: hasDefaultCreds,
         isUnknownDevice: isUnknownDevice,
         hasHostname: hasHostname,
       );

  DeviceSecurityScoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.openPorts,
    required this.hasDefaultCreds,
    required this.isUnknownDevice,
    required this.hasHostname,
  }) : super.internal();

  final List<int> openPorts;
  final bool hasDefaultCreds;
  final bool isUnknownDevice;
  final bool hasHostname;

  @override
  Override overrideWith(int Function(DeviceSecurityScoreRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: DeviceSecurityScoreProvider._internal(
        (ref) => create(ref as DeviceSecurityScoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        openPorts: openPorts,
        hasDefaultCreds: hasDefaultCreds,
        isUnknownDevice: isUnknownDevice,
        hasHostname: hasHostname,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _DeviceSecurityScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceSecurityScoreProvider &&
        other.openPorts == openPorts &&
        other.hasDefaultCreds == hasDefaultCreds &&
        other.isUnknownDevice == isUnknownDevice &&
        other.hasHostname == hasHostname;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, openPorts.hashCode);
    hash = _SystemHash.combine(hash, hasDefaultCreds.hashCode);
    hash = _SystemHash.combine(hash, isUnknownDevice.hashCode);
    hash = _SystemHash.combine(hash, hasHostname.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeviceSecurityScoreRef on AutoDisposeProviderRef<int> {
  /// The parameter `openPorts` of this provider.
  List<int> get openPorts;

  /// The parameter `hasDefaultCreds` of this provider.
  bool get hasDefaultCreds;

  /// The parameter `isUnknownDevice` of this provider.
  bool get isUnknownDevice;

  /// The parameter `hasHostname` of this provider.
  bool get hasHostname;
}

class _DeviceSecurityScoreProviderElement
    extends AutoDisposeProviderElement<int>
    with DeviceSecurityScoreRef {
  _DeviceSecurityScoreProviderElement(super.provider);

  @override
  List<int> get openPorts => (origin as DeviceSecurityScoreProvider).openPorts;
  @override
  bool get hasDefaultCreds =>
      (origin as DeviceSecurityScoreProvider).hasDefaultCreds;
  @override
  bool get isUnknownDevice =>
      (origin as DeviceSecurityScoreProvider).isUnknownDevice;
  @override
  bool get hasHostname => (origin as DeviceSecurityScoreProvider).hasHostname;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
