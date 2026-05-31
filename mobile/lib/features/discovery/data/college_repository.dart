import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';
import '../domain/college_model.dart';

part 'college_repository.g.dart';

class CollegeRepository {
  final Dio _dio;

  CollegeRepository(this._dio);

  Future<List<College>> getColleges({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/colleges', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final List data = response.data['data'];
      return data.map((json) => College.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<College> getCollegeBySlug(String slug) async {
    try {
      final response = await _dio.get('/colleges/$slug');
      return College.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
CollegeRepository collegeRepository(CollegeRepositoryRef ref) {
  return CollegeRepository(ref.watch(dioProvider));
}
