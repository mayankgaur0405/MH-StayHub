import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/utils/errors/api_error_handler.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<void> sendOTP(String phone) async {
    try {
      await _dio.post('/auth/send-otp', data: {'phone': phone});
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<({User user, String token})> verifyOTP(String phone, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
      });

      final data = response.data['data'];
      final user = User.fromJson(data['user']);
      final token = data['token'] as String;

      return (user: user, token: token);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(dioProvider));
}
