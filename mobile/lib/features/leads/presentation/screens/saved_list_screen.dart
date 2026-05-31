import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../providers/saved_accommodation_provider.dart';

class SavedListScreen extends ConsumerWidget {
  const SavedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedAccommodationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Properties')),
      body: savedAsync.when(
        data: (accommodations) {
          if (accommodations.isEmpty) {
            return const Center(child: Text('You have no saved properties.'));
          }
          return ListView.builder(
            itemCount: accommodations.length,
            itemBuilder: (context, index) {
              final acc = accommodations[index];
              return ListTile(
                leading: const Icon(Icons.home, color: AppTheme.brandPrimary),
                title: Text(acc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('₹${acc.startingPrice.toInt()} • ${acc.type}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    ref.read(savedAccommodationsProvider.notifier).unsave(acc.id);
                  },
                ),
                onTap: () {
                  context.push('/accommodations/${acc.slug}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorView(
          message: 'Failed to load saved properties.',
          onRetry: () => ref.invalidate(savedAccommodationsProvider),
        ),
      ),
    );
  }
}
