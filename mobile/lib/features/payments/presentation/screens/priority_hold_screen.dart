import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/payment_provider.dart';

class PriorityHoldScreen extends ConsumerStatefulWidget {
  final String accommodationId;
  final String accommodationName;

  const PriorityHoldScreen({
    super.key,
    required this.accommodationId,
    required this.accommodationName,
  });

  @override
  ConsumerState<PriorityHoldScreen> createState() => _PriorityHoldScreenState();
}

class _PriorityHoldScreenState extends ConsumerState<PriorityHoldScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    AnalyticsTracker.trackPaymentStarted(widget.accommodationId);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // DO NOT trust this success event. We MUST verify with the backend.
    // Navigate to processing screen where verifySignature is called.
    context.go(
      '/payment-processing',
      extra: {
        'orderId': response.orderId,
        'paymentId': response.paymentId,
        'signature': response.signature,
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AnalyticsTracker.trackPaymentFailed(response.message ?? 'Unknown Error');
    ref.read(paymentControllerProvider.notifier).fail(response.message ?? 'Payment cancelled or failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('External Wallets not supported for Priority Hold')));
  }

  void _openCheckout(String orderId, int amount) {
    final key = dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_placeholder';
    var options = {
      'key': key,
      'amount': amount, // in paise
      'name': 'MH StayHub',
      'order_id': orderId,
      'description': 'Priority Hold: ${widget.accommodationName}',
      'prefill': {
        'contact': '', // Could prefill from user profile
        'email': ''
      },
      'theme': {
        'color': '#3b82f6' // brandPrimary
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ref.read(paymentControllerProvider.notifier).fail(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentControllerProvider);

    ref.listen<PaymentState>(paymentControllerProvider, (prev, next) {
      if (next is PaymentOrderCreated) {
        _openCheckout(next.orderId, next.amount);
      } else if (next is PaymentFailure) {
        context.push('/payment-failure', extra: next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Priority Hold')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_user, size: 64, color: AppTheme.brandPrimary),
                const SizedBox(height: 24),
                const Text(
                  'Priority Hold Request',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hold Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const Text('₹99', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: const Text(
                          'This does not guarantee a booking. It places your request in priority review for ${widget.accommodationName}.',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(paymentControllerProvider.notifier).startPayment(widget.accommodationId);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pay & Hold', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          if (paymentState is PaymentOrderCreating)
            const FullScreenLoader(message: 'Initializing Secure Payment...'),
        ],
      ),
    );
  }
}
