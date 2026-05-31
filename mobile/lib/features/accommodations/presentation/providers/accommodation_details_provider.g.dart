// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accommodation_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accommodationDetailsHash() =>
    r'887696ce5715711216c30ef39ac6a89f6d035cd3';

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

/// See also [accommodationDetails].
@ProviderFor(accommodationDetails)
const accommodationDetailsProvider = AccommodationDetailsFamily();

/// See also [accommodationDetails].
class AccommodationDetailsFamily extends Family<AsyncValue<Accommodation>> {
  /// See also [accommodationDetails].
  const AccommodationDetailsFamily();

  /// See also [accommodationDetails].
  AccommodationDetailsProvider call(
    String slug,
  ) {
    return AccommodationDetailsProvider(
      slug,
    );
  }

  @override
  AccommodationDetailsProvider getProviderOverride(
    covariant AccommodationDetailsProvider provider,
  ) {
    return call(
      provider.slug,
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
  String? get name => r'accommodationDetailsProvider';
}

/// See also [accommodationDetails].
class AccommodationDetailsProvider
    extends AutoDisposeFutureProvider<Accommodation> {
  /// See also [accommodationDetails].
  AccommodationDetailsProvider(
    String slug,
  ) : this._internal(
          (ref) => accommodationDetails(
            ref as AccommodationDetailsRef,
            slug,
          ),
          from: accommodationDetailsProvider,
          name: r'accommodationDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accommodationDetailsHash,
          dependencies: AccommodationDetailsFamily._dependencies,
          allTransitiveDependencies:
              AccommodationDetailsFamily._allTransitiveDependencies,
          slug: slug,
        );

  AccommodationDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<Accommodation> Function(AccommodationDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccommodationDetailsProvider._internal(
        (ref) => create(ref as AccommodationDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Accommodation> createElement() {
    return _AccommodationDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccommodationDetailsProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccommodationDetailsRef on AutoDisposeFutureProviderRef<Accommodation> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _AccommodationDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Accommodation>
    with AccommodationDetailsRef {
  _AccommodationDetailsProviderElement(super.provider);

  @override
  String get slug => (origin as AccommodationDetailsProvider).slug;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
