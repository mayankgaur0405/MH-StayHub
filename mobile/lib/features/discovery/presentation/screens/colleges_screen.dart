import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../providers/discovery_providers.dart';

class CollegesScreen extends ConsumerWidget {
  const CollegesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collegesAsync = ref.watch(popularCollegesProvider); // Ideally a paginated provider, but using popular for now

    return Scaffold(
      appBar: AppBar(title: const Text('Colleges')),
      body: collegesAsync.when(
        data: (colleges) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: colleges.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final college = colleges[index];
            return InkWell(
              onTap: () {
                AnalyticsTracker.trackViewCollege(college.id, college.name);
                context.push('/colleges/${college.slug}');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(college.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${college.city}, ${college.state}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }
}
