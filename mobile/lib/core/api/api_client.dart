import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';
import 'secure_storage.dart';

part 'api_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000/api/v1';
  final logger = Logger();
  final secureStorage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Inject token if available
        final token = await secureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        logger.d('➡️ [${options.method}] ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('✅ [${response.statusCode}] ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        logger.e('❌ [${e.response?.statusCode}] ${e.requestOptions.uri}\nError: ${e.message}');
        // Global handling of 401 could dispatch a logout event here if needed
        return handler.next(e);
      },
    ),
  );

  return dio;
}
