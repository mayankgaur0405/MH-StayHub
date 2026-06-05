import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_hub_providers.dart';

class StudentAdvantageScreen extends ConsumerWidget {
  const StudentAdvantageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final couponsAsync = ref.watch(couponsProvider);

    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC);
    final cardColor = isDark ? const Color(0xFF131825) : Colors.white;
    final borderColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC);
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Student Advantage', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: couponsAsync.when(
        data: (coupons) {
          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer_outlined, size: 64, color: mutedColor),
                  const SizedBox(height: 16),
                  Text('No deals available yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text('Check back soon for exclusive offers!', style: TextStyle(color: mutedColor)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(couponsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final category = coupon['category'] ?? 'other';
                final categoryIcon = _categoryIcon(category);
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
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(categoryIcon, color: categoryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon['partnerName'] ?? 'Partner',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coupon['description'] ?? '',
                                style: TextStyle(color: mutedColor, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C3CE1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      coupon['code'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF6C3CE1),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    coupon['discountAmount'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: const Color(0xFF10B981),
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
              Text('Could not load deals', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(couponsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'food': return Icons.restaurant_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      case 'education': return Icons.school_rounded;
      case 'lifestyle': return Icons.spa_rounded;
      default: return Icons.local_offer_rounded;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'food': return const Color(0xFFF59E0B);
      case 'shopping': return const Color(0xFFEC4899);
      case 'education': return const Color(0xFF6C3CE1);
      case 'lifestyle': return const Color(0xFF14B8A6);
      default: return const Color(0xFF6B7280);
    }
  }
}
