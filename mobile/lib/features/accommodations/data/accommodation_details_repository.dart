import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';
import '../../discovery/domain/accommodation_model.dart';

part 'accommodation_details_repository.g.dart';

class AccommodationDetailsRepository {
  final Dio _dio;

  AccommodationDetailsRepository(this._dio);

  Future<Accommodation> getAccommodationDetails(String slug) async {
    try {
      final response = await _dio.get('/accommodations/$slug');
      return Accommodation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
AccommodationDetailsRepository accommodationDetailsRepository(AccommodationDetailsRepositoryRef ref) {
  return AccommodationDetailsRepository(ref.watch(dioProvider));
}
