// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssdp_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ssdpScannerHash() => r'063e6ac7685ccd7a345420e4aee2eb84ff05eeb3';

/// See also [SsdpScanner].
@ProviderFor(SsdpScanner)
final ssdpScannerProvider =
    AutoDisposeAsyncNotifierProvider<SsdpScanner, List<SsdpDevice>>.internal(
      SsdpScanner.new,
      name: r'ssdpScannerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ssdpScannerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SsdpScanner = AutoDisposeAsyncNotifier<List<SsdpDevice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
