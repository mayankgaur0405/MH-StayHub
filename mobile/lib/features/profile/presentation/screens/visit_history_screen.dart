import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../../../../core/utils/loading/skeleton_loader.dart';
import '../providers/profile_provider.dart';

class VisitHistoryScreen extends ConsumerWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(visitRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Visit Requests')),
      body: visitsAsync.when(
        data: (visits) {
          if (visits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No visit requests yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Schedule a visit to see it here.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(visitRequestsProvider);
              await ref.read(visitRequestsProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final visit = visits[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      // Status indicator
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _statusColor(visit.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_statusIcon(visit.status), color: _statusColor(visit.status)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              visit.accommodation,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              visit.preferredDate,
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(visit.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          visit.status.toUpperCase(),
                          style: TextStyle(
                            color: _statusColor(visit.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonLoader(width: double.infinity, height: 80, borderRadius: 16),
          ),
        ),
        error: (err, _) => ErrorView(
          message: 'Failed to load visit requests.',
          onRetry: () => ref.invalidate(visitRequestsProvider),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.success;
      case 'cancelled':
        return AppTheme.error;
      case 'completed':
        return AppTheme.brandSecondary;
      case 'pending':
      default:
        return AppTheme.brandAccent;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.done_all;
      case 'pending':
      default:
        return Icons.schedule;
    }
  }
}
