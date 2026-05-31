import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../discovery/domain/accommodation_model.dart';
import '../data/accommodation_details_repository.dart';

part 'accommodation_details_provider.g.dart';

@riverpod
Future<Accommodation> accommodationDetails(AccommodationDetailsRef ref, String slug) async {
  return ref.watch(accommodationDetailsRepositoryProvider).getAccommodationDetails(slug);
}
