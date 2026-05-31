// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileHash() => r'bf856f2bf7fcd06743cd2951641f82bd8a358ee2';

/// See also [userProfile].
@ProviderFor(userProfile)
final userProfileProvider = AutoDisposeFutureProvider<User>.internal(
  userProfile,
  name: r'userProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRef = AutoDisposeFutureProviderRef<User>;
String _$visitRequestsHash() => r'510898ee056a6e731b6ffd0b75ebe205b44489e8';

/// See also [visitRequests].
@ProviderFor(visitRequests)
final visitRequestsProvider = AutoDisposeFutureProvider<List<Lead>>.internal(
  visitRequests,
  name: r'visitRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visitRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisitRequestsRef = AutoDisposeFutureProviderRef<List<Lead>>;
String _$updateProfileHash() => r'dbf56a32488a938dc58cca3239db65f7cf94dbcd';

/// See also [UpdateProfile].
@ProviderFor(UpdateProfile)
final updateProfileProvider =
    AutoDisposeAsyncNotifierProvider<UpdateProfile, void>.internal(
  UpdateProfile.new,
  name: r'updateProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateProfile = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
