import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiErrorHandler {
  static final Logger _logger = Logger();

  static String handle(DioException error) {
    _logger.e('API Error: ${error.type} - ${error.message}', error: error);

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please try again.';
    }

    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;
      
      String message = 'An unexpected error occurred.';
      if (data != null && data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'];
      }

      switch (statusCode) {
        case 400:
          return message; // Bad Request
        case 401:
          // Global unauthenticated handling can trigger a logout via Riverpod later
          return 'Unauthorized. Please login again.';
        case 403:
          return 'Forbidden. You do not have permission for this action.';
        case 404:
          return 'Resource not found.';
        case 500:
        case 502:
        case 503:
        case 504:
          return 'Server error. Our team has been notified. Please try again later.';
        default:
          return message;
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
