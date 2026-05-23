// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mdns_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mdnsScannerHash() => r'ba24b003d6aedd9f6cfa4d6b001a654642aa78a5';

/// See also [MdnsScanner].
@ProviderFor(MdnsScanner)
final mdnsScannerProvider =
    AutoDisposeAsyncNotifierProvider<MdnsScanner, List<MdnsDevice>>.internal(
      MdnsScanner.new,
      name: r'mdnsScannerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mdnsScannerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MdnsScanner = AutoDisposeAsyncNotifier<List<MdnsDevice>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
