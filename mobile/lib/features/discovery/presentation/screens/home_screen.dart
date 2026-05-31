import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/loading/skeleton_loader.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../providers/discovery_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collegesAsync = ref.watch(popularCollegesProvider);
    final featuredAsync = ref.watch(featuredAccommodationsProvider);
    final authState = ref.watch(authControllerProvider);
    
    String userName = 'Student';
    if (authState is AuthAuthenticated && authState.user.name != null) {
      userName = authState.user.name!;
    }

    Future<void> onRefresh() async {
      ref.invalidate(popularCollegesProvider);
      ref.invalidate(featuredAccommodationsProvider);
      // Wait for the new futures to complete
      await Future.wait([
        ref.read(popularCollegesProvider.future),
        ref.read(featuredAccommodationsProvider.future),
      ]);
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            // App Bar / Header
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.brandPrimary,
              foregroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi, $userName 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('Find your perfect stay', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                )
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: InkWell(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: AppTheme.textSecondary),
                          SizedBox(width: 8),
                          Text('Search by college, location...', style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Popular Colleges
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Popular Colleges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => context.push('/colleges'),
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
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
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppTheme.brandPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.school, color: AppTheme.brandPrimary),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  college.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                      child: SkeletonLoader(width: 100, height: 120, borderRadius: 12),
                    ),
                  ),
                  error: (err, stack) => Center(child: Text('Failed to load colleges', style: TextStyle(color: Colors.red))),
                ),
              ),
            ),

            // Featured Accommodations
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text('Featured Accommodations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            featuredAsync.when(
              data: (accommodations) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final acc = accommodations[index];
                    return GestureDetector(
                      onTap: () => context.push('/accommodations/${acc.slug}'),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              // In prod, use CachedNetworkImage
                              child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          acc.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (acc.verificationStatus != 'unverified')
                                        const Icon(Icons.verified, color: AppTheme.success, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(acc.address, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${acc.startingPrice.toInt()}/month',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppTheme.brandPrimary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          acc.type.toUpperCase(),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
