import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid 10-digit phone number'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedPhone = '+91$phone'; // Hardcoding India code for now based on context
      await ref.read(authControllerProvider.notifier).sendOTP(formattedPhone);
      if (mounted) {
        context.push('/otp', extra: formattedPhone);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.foregroundDark : AppTheme.foreground;
    final mutedColor = isDark ? AppTheme.mutedDark : AppTheme.muted;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppTheme.brandPrimary, AppTheme.brandPrimaryLight]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
                      ),
                      const SizedBox(width: 8),
                      Text('MH ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor)),
                      const Text('StayHub', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.brandPrimary)),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome to\nMH StayHub ✨',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -1,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your mobile number to login or register. We\'ll send you an OTP to verify.',
                    style: TextStyle(fontSize: 16, color: mutedColor, height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.brandPrimary.withOpacity(isDark ? 0.1 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor, letterSpacing: 1),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(fontSize: 15, color: mutedColor, fontWeight: FontWeight.normal, letterSpacing: 0),
                        prefixText: '+91  ',
                        prefixStyle: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1),
                        counterText: '',
                        prefixIcon: Icon(Icons.phone_iphone_rounded, color: AppTheme.brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                      ),
                      child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: mutedColor, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) const FullScreenLoader(message: 'Sending OTP...'),
        ],
      ),
    );
  }
}
