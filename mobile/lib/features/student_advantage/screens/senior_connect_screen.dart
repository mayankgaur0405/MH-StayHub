import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_hub_providers.dart';

class SeniorConnectScreen extends ConsumerWidget {
  const SeniorConnectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final queriesAsync = ref.watch(seniorQueriesProvider);

    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC);
    final cardColor = isDark ? const Color(0xFF131825) : Colors.white;
    final borderColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC);
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Senior Connect', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF6C3CE1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Ask a Question', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: queriesAsync.when(
        data: (queries) {
          if (queries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 64, color: mutedColor),
                  const SizedBox(height: 16),
                  Text('No discussions yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text('Ask seniors anything about college life!', style: TextStyle(color: mutedColor)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(seniorQueriesProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: queries.length,
              itemBuilder: (context, index) {
                final query = queries[index];
                final category = query['category'] ?? 'general';
                final status = query['status'] ?? 'open';
                final replies = query['replies'] as List? ?? [];
                final categoryColor = _categoryColor(category);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _categoryLabel(category),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: categoryColor),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _statusColor(status)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          query['title'] ?? 'Untitled',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          query['content'] ?? '',
                          style: TextStyle(color: mutedColor, fontSize: 13, height: 1.5),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 16, color: mutedColor),
                            const SizedBox(width: 6),
                            Text(
                              '${replies.length} ${replies.length == 1 ? 'reply' : 'replies'}',
                              style: TextStyle(fontSize: 13, color: mutedColor),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('View Thread →', style: TextStyle(color: Color(0xFF6C3CE1), fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: const Color(0xFF6C3CE1))),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: mutedColor),
              const SizedBox(height: 12),
              Text('Could not load discussions', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => ref.invalidate(seniorQueriesProvider), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'guidance': return const Color(0xFF6C3CE1);
      case 'referral': return const Color(0xFF14B8A6);
      case 'academics': return const Color(0xFF3B82F6);
      default: return const Color(0xFFF59E0B);
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'guidance': return '🧭 GUIDANCE';
      case 'referral': return '🔗 REFERRAL';
      case 'academics': return '📚 ACADEMICS';
      default: return '💬 GENERAL';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'open': return const Color(0xFF10B981);
      case 'answered': return const Color(0xFF3B82F6);
      case 'closed': return const Color(0xFF6B7280);
      default: return const Color(0xFF6B7280);
    }
  }
}
