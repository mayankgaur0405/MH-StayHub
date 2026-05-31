import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/payment_repository.dart';

part 'payment_provider.g.dart';

// Represents the state of the payment flow
sealed class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentOrderCreating extends PaymentState {}
class PaymentOrderCreated extends PaymentState {
  final String orderId;
  final int amount;
  PaymentOrderCreated(this.orderId, this.amount);
}
class PaymentVerifying extends PaymentState {}
class PaymentSuccess extends PaymentState {}
class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}

@riverpod
class PaymentController extends _$PaymentController {
  @override
  PaymentState build() {
    return PaymentInitial();
  }

  Future<void> startPayment(String accommodationId) async {
    state = PaymentOrderCreating();
    try {
      final data = await ref.read(paymentRepositoryProvider).createOrder(accommodationId);
      state = PaymentOrderCreated(data['orderId'], data['amount']);
    } catch (e) {
      state = PaymentFailure(e.toString());
    }
  }

  Future<void> verifySignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    // Only verify if we are not already verifying or successful (Idempotency check on client)
    if (state is PaymentVerifying || state is PaymentSuccess) return;
    
    state = PaymentVerifying();
    try {
      await ref.read(paymentRepositoryProvider).verifyPayment(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );
      state = PaymentSuccess();
    } catch (e) {
      state = PaymentFailure(e.toString());
    }
  }

  void fail(String message) {
    state = PaymentFailure(message);
  }

  void reset() {
    state = PaymentInitial();
  }
}
