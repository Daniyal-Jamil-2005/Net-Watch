// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wifiSsidHash() => r'c470d6c0c747e71b6a256d36912e73c8415f5dc3';

/// See also [wifiSsid].
@ProviderFor(wifiSsid)
final wifiSsidProvider = AutoDisposeFutureProvider<String>.internal(
  wifiSsid,
  name: r'wifiSsidProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wifiSsidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WifiSsidRef = AutoDisposeFutureProviderRef<String>;
String _$networkSpeedHash() => r'7fa8362b893ca29855382874ddc2bb5eb5231e4d';

/// See also [networkSpeed].
@ProviderFor(networkSpeed)
final networkSpeedProvider = AutoDisposeStreamProvider<double>.internal(
  networkSpeed,
  name: r'networkSpeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkSpeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetworkSpeedRef = AutoDisposeStreamProviderRef<double>;
String _$networkDevicesHash() => r'ebfe9d25498685c30bfe1ad80713c92c6c65e35c';

/// See also [networkDevices].
@ProviderFor(networkDevices)
final networkDevicesProvider = FutureProvider<List<NetworkDevice>>.internal(
  networkDevices,
  name: r'networkDevicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetworkDevicesRef = FutureProviderRef<List<NetworkDevice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
