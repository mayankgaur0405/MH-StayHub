import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../../../../core/utils/loading/skeleton_loader.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../leads/presentation/providers/saved_accommodation_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsTracker.trackViewProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final savedAsync = ref.watch(savedAccommodationsProvider);
    final visitAsync = ref.watch(visitRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(savedAccommodationsProvider);
          ref.invalidate(visitRequestsProvider);
          await ref.read(userProfileProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Card
            profileAsync.when(
              data: (user) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.brandPrimary, AppTheme.brandPrimaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          (user.name ?? user.phone).substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name ?? 'Student',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(user.email!, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => context.push('/edit-profile'),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const SkeletonLoader(width: double.infinity, height: 220, borderRadius: 20),
              error: (err, _) => ErrorView(message: err.toString(), onRetry: () => ref.invalidate(userProfileProvider)),
            ),

            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.favorite,
                    label: 'Saved',
                    count: savedAsync.whenOrNull(data: (list) => list.length) ?? 0,
                    color: Colors.redAccent,
                    onTap: () {
                      AnalyticsTracker.trackViewSavedProperties();
                      context.push('/saved');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today,
                    label: 'Visits',
                    count: visitAsync.whenOrNull(data: (list) => list.length) ?? 0,
                    color: AppTheme.brandSecondary,
                    onTap: () {
                      AnalyticsTracker.trackViewVisitHistory();
                      context.push('/visit-history');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Menu Items
            _MenuTile(
              icon: Icons.favorite_outline,
              title: 'Saved Properties',
              onTap: () {
                AnalyticsTracker.trackViewSavedProperties();
                context.push('/saved');
              },
            ),
            _MenuTile(
              icon: Icons.history,
              title: 'Visit Requests',
              onTap: () {
                AnalyticsTracker.trackViewVisitHistory();
                context.push('/visit-history');
              },
            ),
            _MenuTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({required this.icon, required this.label, required this.count, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.brandPrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
