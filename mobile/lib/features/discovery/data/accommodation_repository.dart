import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';
import '../domain/accommodation_model.dart';

part 'accommodation_repository.g.dart';

class AccommodationRepository {
  final Dio _dio;

  AccommodationRepository(this._dio);

  Future<List<Accommodation>> getAccommodations({
    int page = 1, 
    int limit = 10,
    String? type,
    String? gender,
    double? maxPrice,
    String? collegeId,
    double? lat,
    double? lng,
    int? radius,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (gender != null) 'gender': gender,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (collegeId != null) 'collegeId': collegeId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (radius != null) 'radius': radius,
      };

      final response = await _dio.get('/accommodations', queryParameters: queryParams);
      final List data = response.data['data'];
      return data.map((json) => Accommodation.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<Accommodation> getAccommodationBySlug(String slug) async {
    try {
      final response = await _dio.get('/accommodations/$slug');
      return Accommodation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
AccommodationRepository accommodationRepository(AccommodationRepositoryRef ref) {
  return AccommodationRepository(ref.watch(dioProvider));
}
