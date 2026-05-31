import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/utils/errors/api_error_handler.dart';
import '../../auth/domain/user_model.dart';
import '../../leads/domain/lead_model.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> updateProfile({String? name, String? email}) async {
    try {
      final response = await _dio.put('/auth/update-profile', data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      });
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<Lead>> getMyVisitRequests() async {
    try {
      final response = await _dio.get('/leads/my-leads');
      final List data = response.data['data'];
      return data.map((json) => Lead.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(dioProvider));
}
