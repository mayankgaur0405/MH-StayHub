import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/utils/loading/skeleton_loader.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../providers/discovery_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final collegesAsync = ref.watch(popularCollegesProvider);
    final featuredAsync = ref.watch(featuredAccommodationsProvider);
    final authState = ref.watch(authControllerProvider);

    String userName = 'Student';
    if (authState is AuthAuthenticated && authState.user.name != null) {
      userName = authState.user.name!;
    }

    final bgColor = isDark ? AppTheme.backgroundDark : AppTheme.background;
    final cardColor = isDark ? AppTheme.surfaceDark : AppTheme.surface;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.border;
    final textColor = isDark ? AppTheme.foregroundDark : AppTheme.foreground;
    final mutedColor = isDark ? AppTheme.mutedDark : AppTheme.muted;
    final surfaceAlt = isDark ? AppTheme.surfaceAltDark : AppTheme.surfaceAlt;

    Future<void> onRefresh() async {
      ref.invalidate(popularCollegesProvider);
      ref.invalidate(featuredAccommodationsProvider);
      await Future.wait([
        ref.read(popularCollegesProvider.future),
        ref.read(featuredAccommodationsProvider.future),
      ]);
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        color: AppTheme.brandPrimary,
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            // ─── Premium Header ──────────────────────────────────
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: cardColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 72,
              title: Row(
                children: [
                  // Logo matching web
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.brandPrimary, AppTheme.brandPrimaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hi, $userName 👋',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -0.3),
                      ),
                      Text(
                        'Find your perfect stay',
                        style: TextStyle(fontSize: 12, color: mutedColor, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20, color: mutedColor),
                  onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                ),
                IconButton(
                  icon: Icon(Icons.logout_rounded, size: 20, color: mutedColor),
                  onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(62),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: InkWell(
                    onTap: () => context.push('/search'),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: surfaceAlt,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: mutedColor, size: 20),
                          const SizedBox(width: 10),
                          Text('Search by college, location...', style: TextStyle(color: mutedColor, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Popular Colleges ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular Colleges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -0.3)),
                    GestureDetector(
                      onTap: () => context.push('/colleges'),
                      child: Text('See All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.brandPrimary)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: collegesAsync.when(
                  data: (colleges) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: colleges.length,
                    itemBuilder: (context, index) {
                      final college = colleges[index];
                      return GestureDetector(
                        onTap: () => context.push('/colleges/${college.slug}'),
                        child: Container(
                          width: 96,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppTheme.brandPrimary.withOpacity(0.1), AppTheme.brandPrimaryLight.withOpacity(0.05)],
                                  ),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                                ),
                                child: const Icon(Icons.school_rounded, color: AppTheme.brandPrimary, size: 22),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  college.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 4,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: SkeletonLoader(width: 96, height: 110, borderRadius: 16),
                    ),
                  ),
                  error: (err, stack) => Center(child: Text('Failed to load', style: TextStyle(color: AppTheme.danger))),
                ),
              ),
            ),

            // ─── Featured Accommodations ─────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                child: Text('Featured Accommodations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -0.3)),
              ),
            ),
            featuredAsync.when(
              data: (accommodations) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final acc = accommodations[index];
                    return GestureDetector(
                      onTap: () => context.push('/accommodations/${acc.slug}'),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image placeholder
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.brandPrimary.withOpacity(isDark ? 0.15 : 0.06),
                                    AppTheme.brandSecondary.withOpacity(isDark ? 0.1 : 0.04),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
                              ),
                              child: Center(
                                child: Icon(Icons.apartment_rounded, color: AppTheme.brandPrimary.withOpacity(0.3), size: 48),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          acc.name,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -0.3),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (acc.verificationStatus != 'unverified')
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.success.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.verified_rounded, color: AppTheme.success, size: 14),
                                              const SizedBox(width: 3),
                                              Text('Verified', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.success)),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 14, color: mutedColor),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(acc.address, style: TextStyle(color: mutedColor, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${acc.startingPrice.toInt()}/month',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.brandPrimary, letterSpacing: -0.5),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppTheme.brandPrimary.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                        ),
                                        child: Text(
                                          acc.type.toUpperCase(),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.brandPrimary, letterSpacing: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: accommodations.length,
                ),
              ),
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: CardSkeleton(),
                  ),
                  childCount: 3,
                ),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: ErrorView(
                  message: 'Could not load accommodations.',
                  onRetry: () => ref.invalidate(featuredAccommodationsProvider),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
