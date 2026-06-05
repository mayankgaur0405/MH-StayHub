import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Find Verified Stays',
      'description': 'Discover hostels and PGs personally verified by our team. Zero surprises, guaranteed.',
      'icon': Icons.verified_user_rounded,
      'color': AppTheme.brandPrimary,
    },
    {
      'title': 'Near Your College',
      'description': 'Search accommodations specifically mapped to your college in Greater Noida.',
      'icon': Icons.school_rounded,
      'color': AppTheme.brandSecondary,
    },
    {
      'title': 'Zero Brokerage',
      'description': 'Connect directly with property owners. No middlemen, no brokerage fees.',
      'icon': Icons.savings_rounded,
      'color': AppTheme.brandAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.foregroundDark : AppTheme.foreground;
    final mutedColor = isDark ? AppTheme.mutedDark : AppTheme.muted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
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
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text('Skip', style: TextStyle(color: mutedColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: (data['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(data['icon'] as IconData, size: 56, color: data['color'] as Color),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          data['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['description'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: mutedColor, height: 1.6),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentPage == index ? 28 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppTheme.brandPrimary : (isDark ? AppTheme.borderDark : AppTheme.border),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          context.go('/login');
                        } else {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Continue',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
