import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../providers/payment_provider.dart';

class PaymentProcessingScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String paymentId;
  final String signature;

  const PaymentProcessingScreen({
    super.key,
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  @override
  ConsumerState<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends ConsumerState<PaymentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentControllerProvider.notifier).verifySignature(
        orderId: widget.orderId,
        paymentId: widget.paymentId,
        signature: widget.signature,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PaymentState>(paymentControllerProvider, (prev, next) {
      if (next is PaymentSuccess) {
        AnalyticsTracker.trackPaymentSuccess(widget.orderId);
        context.go('/payment-success');
      } else if (next is PaymentFailure) {
        AnalyticsTracker.trackPaymentFailed(next.message);
        context.go('/payment-failure', extra: next.message);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.brandPrimary),
            const SizedBox(height: 24),
            const Text(
              'Verifying Payment securely...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please do not close the app.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
