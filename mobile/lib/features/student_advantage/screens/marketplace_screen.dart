import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_hub_providers.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final itemsAsync = ref.watch(marketplaceItemsProvider);

    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC);
    final cardColor = isDark ? const Color(0xFF131825) : Colors.white;
    final borderColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC);
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Student Marketplace', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF6C3CE1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Sell Item', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, size: 64, color: mutedColor),
                  const SizedBox(height: 16),
                  Text('Marketplace is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text('List your items to get started!', style: TextStyle(color: mutedColor)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(marketplaceItemsProvider),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final category = item['category'] ?? 'other';
                final condition = item['condition'] ?? 'good';

                return Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image area
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: _categoryColor(category).withOpacity(0.08),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(_categoryIcon(category), size: 40, color: _categoryColor(category)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? 'Item',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _categoryColor(category).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    category.toUpperCase(),
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _categoryColor(category)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  condition.replaceAll('_', ' '),
                                  style: TextStyle(fontSize: 11, color: mutedColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${item['price'] ?? 0}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF6C3CE1)),
                            ),
                          ],
                        ),
                      ),
                    ],
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
              Text('Could not load items', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => ref.invalidate(marketplaceItemsProvider), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'books': return Icons.menu_book_rounded;
      case 'cycles': return Icons.pedal_bike_rounded;
      case 'electronics': return Icons.devices_rounded;
      case 'furniture': return Icons.chair_rounded;
      default: return Icons.shopping_bag_rounded;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'books': return const Color(0xFF3B82F6);
      case 'cycles': return const Color(0xFF10B981);
      case 'electronics': return const Color(0xFFF59E0B);
      case 'furniture': return const Color(0xFFEC4899);
      default: return const Color(0xFF6B7280);
    }
  }
}
