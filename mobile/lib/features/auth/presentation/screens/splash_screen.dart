import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(AuthState authState) {
    if (_navigated || !mounted) return;

    if (authState is AuthAuthenticated) {
      _navigated = true;
      context.go('/home');
    } else if (authState is AuthUnauthenticated || authState is AuthError) {
      _navigated = true;
      context.go('/onboarding');
    }
    // AuthInitial and AuthLoading: do nothing, wait for a terminal state
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes and navigate when we get a terminal state
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      _navigate(next);
    });

    // Also check the current state on every build (handles the case where
    // the auth check completed before ref.listen was registered)
    final currentAuth = ref.watch(authControllerProvider);
    // Use addPostFrameCallback to avoid navigating during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate(currentAuth);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C3CE1), Color(0xFF4F46E5), Color(0xFF14B8A6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, spreadRadius: 2),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'M',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppTheme.brandPrimary, letterSpacing: -2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'MH StayHub',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Student Accommodation, Simplified.',
                        style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
