import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/utils/errors/api_error_handler.dart';

part 'payment_repository.g.dart';

class PaymentRepository {
  final Dio _dio;

  PaymentRepository(this._dio);

  Future<Map<String, dynamic>> createOrder(String accommodationId) async {
    try {
      final response = await _dio.post('/payments/create-order', data: {
        'accommodationId': accommodationId,
      });
      return response.data['data'];
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      await _dio.post('/payments/verify-payment', data: {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      });
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

@riverpod
PaymentRepository paymentRepository(PaymentRepositoryRef ref) {
  return PaymentRepository(ref.watch(dioProvider));
}
