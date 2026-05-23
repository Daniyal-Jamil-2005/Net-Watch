// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'netbios_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$netbiosScannerHash() => r'1acff42589a85ce91dff97bfd7fc0158ad6177e4';

/// See also [NetbiosScanner].
@ProviderFor(NetbiosScanner)
final netbiosScannerProvider =
    AutoDisposeAsyncNotifierProvider<
      NetbiosScanner,
      List<NetbiosResult>
    >.internal(
      NetbiosScanner.new,
      name: r'netbiosScannerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$netbiosScannerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NetbiosScanner = AutoDisposeAsyncNotifier<List<NetbiosResult>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
