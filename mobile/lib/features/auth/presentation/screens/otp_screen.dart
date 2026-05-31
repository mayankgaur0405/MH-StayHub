import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) { // Dev bypass assumes 123456
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).verifyOTP(widget.phone, otp);
      // AuthController will update state to AuthAuthenticated.
      // We can route from here or let a router listener handle it.
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verify Phone 📱',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a 6-digit OTP to ${widget.phone}.',
                    style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _verifyOtp,
                      child: const Text('Verify & Login'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Resend logic
                        ref.read(authControllerProvider.notifier).sendOTP(widget.phone);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP Resent')));
                      },
                      child: const Text('Resend OTP', style: TextStyle(color: AppTheme.brandPrimary)),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isLoading) const FullScreenLoader(message: 'Verifying...'),
        ],
      ),
    );
  }
}
