import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/college_repository.dart';
import '../../data/accommodation_repository.dart';
import '../../domain/college_model.dart';
import '../../domain/accommodation_model.dart';

part 'discovery_providers.g.dart';

@riverpod
Future<List<College>> popularColleges(PopularCollegesRef ref) async {
  return ref.watch(collegeRepositoryProvider).getColleges(limit: 6);
}

@riverpod
Future<List<Accommodation>> featuredAccommodations(FeaturedAccommodationsRef ref) async {
  return ref.watch(accommodationRepositoryProvider).getAccommodations(limit: 5);
}

@riverpod
Future<List<Accommodation>> accommodationsByCollege(
  AccommodationsByCollegeRef ref, 
  String collegeId,
) async {
  return ref.watch(accommodationRepositoryProvider).getAccommodations(
    collegeId: collegeId, 
    limit: 10,
  );
}

@riverpod
class SearchAccommodations extends _$SearchAccommodations {
  @override
  FutureOr<List<Accommodation>> build() async {
    return [];
  }

  Future<void> search({
    String? type,
    String? gender,
    double? maxPrice,
    String? collegeId,
    double? lat,
    double? lng,
    int? radius,
  }) async {
    state = const AsyncValue.loading();
    try {
      final results = await ref.read(accommodationRepositoryProvider).getAccommodations(
        type: type,
        gender: gender,
        maxPrice: maxPrice,
        collegeId: collegeId,
        lat: lat,
        lng: lng,
        radius: radius,
        limit: 20,
      );
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
