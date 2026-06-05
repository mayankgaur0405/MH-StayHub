import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/discovery/presentation/screens/home_screen.dart';
import '../../features/discovery/presentation/screens/search_screen.dart';
import '../../features/discovery/presentation/screens/colleges_screen.dart';
import '../../features/discovery/presentation/screens/college_details_screen.dart';
import '../../features/accommodations/presentation/screens/accommodation_details_screen.dart';
import '../../features/accommodations/presentation/screens/full_gallery_screen.dart';
import '../../features/leads/presentation/screens/schedule_visit_screen.dart';
import '../../features/leads/presentation/screens/saved_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/visit_history_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/payments/presentation/screens/priority_hold_screen.dart';
import '../../features/payments/presentation/screens/payment_processing_screen.dart';
import '../../features/payments/presentation/screens/payment_success_screen.dart';
import '../../features/payments/presentation/screens/payment_failure_screen.dart';
import '../../features/student_advantage/screens/command_center_screen.dart';
import '../../features/student_advantage/screens/student_advantage_screen.dart';
import '../../features/student_advantage/screens/career_hub_screen.dart';
import '../../features/student_advantage/screens/roommate_finder_screen.dart';
import '../../features/student_advantage/screens/marketplace_screen.dart';
import '../../features/student_advantage/screens/senior_connect_screen.dart';
import '../theme/app_theme.dart';

part 'app_router.g.dart';

/// Shell for bottom navigation bar on main tabs
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabs = ['/home', '/search', '/hub', '/saved', '/profile'];

  @override
  Widget build(BuildContext context) {
    // Sync _currentIndex with the current route
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) {
        if (_currentIndex != i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = i);
          });
        }
        break;
      }
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          context.go(_tabs[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Hub'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth routes (no bottom bar)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phone: phone);
        },
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/hub',
            builder: (context, state) => const CommandCenterScreen(),
          ),
          GoRoute(
            path: '/saved',
            builder: (context, state) => const SavedListScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Student Hub sub-routes (pushed on top, no bottom bar)
      GoRoute(
        path: '/advantage',
        builder: (context, state) => const StudentAdvantageScreen(),
      ),
      GoRoute(
        path: '/career-hub',
        builder: (context, state) => const CareerHubScreen(),
      ),
      GoRoute(
        path: '/roommates',
        builder: (context, state) => const RoommateFinderScreen(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/senior-connect',
        builder: (context, state) => const SeniorConnectScreen(),
      ),

      // Detail routes (pushed on top of shell, no bottom bar)
      GoRoute(
        path: '/colleges',
        builder: (context, state) => const CollegesScreen(),
      ),
      GoRoute(
        path: '/colleges/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return CollegeDetailsScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/accommodations/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return AccommodationDetailsScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/gallery',
        builder: (context, state) {
          final images = state.extra as List<String>? ?? [];
          return FullGalleryScreen(images: images);
        },
      ),
      GoRoute(
        path: '/schedule-visit',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return ScheduleVisitScreen(
            accommodationId: extra['id'] ?? '',
            accommodationName: extra['name'] ?? 'Accommodation',
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/visit-history',
        builder: (context, state) => const VisitHistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/priority-hold',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return PriorityHoldScreen(
            accommodationId: extra['id'] ?? '',
            accommodationName: extra['name'] ?? 'Accommodation',
          );
        },
      ),
      GoRoute(
        path: '/payment-processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentProcessingScreen(
            orderId: extra['orderId'],
            paymentId: extra['paymentId'],
            signature: extra['signature'],
          );
        },
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/payment-failure',
        builder: (context, state) {
          final msg = state.extra as String? ?? 'Payment failed';
          return PaymentFailureScreen(errorMsg: msg);
        },
      ),
    ],
  );
}
