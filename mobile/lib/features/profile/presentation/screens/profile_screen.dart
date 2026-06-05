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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profileAsync = ref.watch(userProfileProvider);
    final savedAsync = ref.watch(savedAccommodationsProvider);
    final visitAsync = ref.watch(visitRequestsProvider);

    final cardColor = isDark ? AppTheme.surfaceDark : AppTheme.surface;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.border;
    final textColor = isDark ? AppTheme.foregroundDark : AppTheme.foreground;
    final mutedColor = isDark ? AppTheme.mutedDark : AppTheme.muted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: mutedColor, size: 22),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.brandPrimary,
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(savedAccommodationsProvider);
          ref.invalidate(visitRequestsProvider);
          await ref.read(userProfileProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ─── Profile Card ─────────────────────────────────────
            profileAsync.when(
              data: (user) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C3CE1), Color(0xFF4F46E5), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                  boxShadow: [
                    BoxShadow(color: AppTheme.brandPrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2.5),
                      ),
                      child: Center(
                        child: Text(
                          (user.name ?? user.phone).substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name ?? 'Student',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(user.phone, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7))),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(user.email!, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                        ),
                        onPressed: () => context.push('/edit-profile'),
                        child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const SkeletonLoader(width: double.infinity, height: 220, borderRadius: 16),
              error: (err, _) => ErrorView(message: err.toString(), onRetry: () => ref.invalidate(userProfileProvider)),
            ),

            const SizedBox(height: 20),

            // ─── Stats Row ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.favorite_rounded,
                    label: 'Saved',
                    count: savedAsync.whenOrNull(data: (list) => list.length) ?? 0,
                    color: AppTheme.danger,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    onTap: () {
                      AnalyticsTracker.trackViewSavedProperties();
                      context.push('/saved');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Visits',
                    count: visitAsync.whenOrNull(data: (list) => list.length) ?? 0,
                    color: AppTheme.brandSecondary,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    onTap: () {
                      AnalyticsTracker.trackViewVisitHistory();
                      context.push('/visit-history');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ─── Menu Items ───────────────────────────────────────
            _MenuTile(icon: Icons.favorite_outline_rounded, title: 'Saved Properties', cardColor: cardColor, borderColor: borderColor, textColor: textColor, mutedColor: mutedColor, onTap: () {
              AnalyticsTracker.trackViewSavedProperties();
              context.push('/saved');
            }),
            const SizedBox(height: 8),
            _MenuTile(icon: Icons.history_rounded, title: 'Visit Requests', cardColor: cardColor, borderColor: borderColor, textColor: textColor, mutedColor: mutedColor, onTap: () {
              AnalyticsTracker.trackViewVisitHistory();
              context.push('/visit-history');
            }),
            const SizedBox(height: 8),
            _MenuTile(icon: Icons.settings_outlined, title: 'Settings', cardColor: cardColor, borderColor: borderColor, textColor: textColor, mutedColor: mutedColor, onTap: () => context.push('/settings')),
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
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon, required this.label, required this.count,
    required this.color, required this.cardColor, required this.borderColor,
    required this.textColor, required this.mutedColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: mutedColor, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon, required this.title, required this.cardColor,
    required this.borderColor, required this.textColor, required this.mutedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.brandPrimary, size: 22),
              const SizedBox(width: 14),
              Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 15))),
              Icon(Icons.chevron_right_rounded, color: mutedColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
