// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$popularCollegesHash() => r'b7c4b724d45566b436fcf0ef62fea1cc5a892fa0';

/// See also [popularColleges].
@ProviderFor(popularColleges)
final popularCollegesProvider =
    AutoDisposeFutureProvider<List<College>>.internal(
  popularColleges,
  name: r'popularCollegesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$popularCollegesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularCollegesRef = AutoDisposeFutureProviderRef<List<College>>;
String _$featuredAccommodationsHash() =>
    r'421b4000cfc23603c74afc15132208fd6e0857ef';

/// See also [featuredAccommodations].
@ProviderFor(featuredAccommodations)
final featuredAccommodationsProvider =
    AutoDisposeFutureProvider<List<Accommodation>>.internal(
  featuredAccommodations,
  name: r'featuredAccommodationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredAccommodationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedAccommodationsRef
    = AutoDisposeFutureProviderRef<List<Accommodation>>;
String _$accommodationsByCollegeHash() =>
    r'139b333c33c458967e665edb4df5a2683db23e76';

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

/// See also [accommodationsByCollege].
@ProviderFor(accommodationsByCollege)
const accommodationsByCollegeProvider = AccommodationsByCollegeFamily();

/// See also [accommodationsByCollege].
class AccommodationsByCollegeFamily
    extends Family<AsyncValue<List<Accommodation>>> {
  /// See also [accommodationsByCollege].
  const AccommodationsByCollegeFamily();

  /// See also [accommodationsByCollege].
  AccommodationsByCollegeProvider call(
    String collegeId,
  ) {
    return AccommodationsByCollegeProvider(
      collegeId,
    );
  }

  @override
  AccommodationsByCollegeProvider getProviderOverride(
    covariant AccommodationsByCollegeProvider provider,
  ) {
    return call(
      provider.collegeId,
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
  String? get name => r'accommodationsByCollegeProvider';
}

/// See also [accommodationsByCollege].
class AccommodationsByCollegeProvider
    extends AutoDisposeFutureProvider<List<Accommodation>> {
  /// See also [accommodationsByCollege].
  AccommodationsByCollegeProvider(
    String collegeId,
  ) : this._internal(
          (ref) => accommodationsByCollege(
            ref as AccommodationsByCollegeRef,
            collegeId,
          ),
          from: accommodationsByCollegeProvider,
          name: r'accommodationsByCollegeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accommodationsByCollegeHash,
          dependencies: AccommodationsByCollegeFamily._dependencies,
          allTransitiveDependencies:
              AccommodationsByCollegeFamily._allTransitiveDependencies,
          collegeId: collegeId,
        );

  AccommodationsByCollegeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collegeId,
  }) : super.internal();

  final String collegeId;

  @override
  Override overrideWith(
    FutureOr<List<Accommodation>> Function(AccommodationsByCollegeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccommodationsByCollegeProvider._internal(
        (ref) => create(ref as AccommodationsByCollegeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collegeId: collegeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Accommodation>> createElement() {
    return _AccommodationsByCollegeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccommodationsByCollegeProvider &&
        other.collegeId == collegeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collegeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccommodationsByCollegeRef
    on AutoDisposeFutureProviderRef<List<Accommodation>> {
  /// The parameter `collegeId` of this provider.
  String get collegeId;
}

class _AccommodationsByCollegeProviderElement
    extends AutoDisposeFutureProviderElement<List<Accommodation>>
    with AccommodationsByCollegeRef {
  _AccommodationsByCollegeProviderElement(super.provider);

  @override
  String get collegeId => (origin as AccommodationsByCollegeProvider).collegeId;
}

String _$searchAccommodationsHash() =>
    r'b9bd5dc2fdd1127cf429d575b6129f56cd5412a8';

/// See also [SearchAccommodations].
@ProviderFor(SearchAccommodations)
final searchAccommodationsProvider = AutoDisposeAsyncNotifierProvider<
    SearchAccommodations, List<Accommodation>>.internal(
  SearchAccommodations.new,
  name: r'searchAccommodationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchAccommodationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchAccommodations = AutoDisposeAsyncNotifier<List<Accommodation>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
