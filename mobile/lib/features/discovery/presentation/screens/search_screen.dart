import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../providers/discovery_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String? _selectedType;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Fetch initial unfiltered results
    Future.microtask(() => ref.read(searchAccommodationsProvider.notifier).search());
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: ['hostel', 'pg', 'coliving'].map((type) {
                      return ChoiceChip(
                        label: Text(type.toUpperCase()),
                        selected: _selectedType == type,
                        onSelected: (val) => setModalState(() => _selectedType = val ? type : null),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: ['boys', 'girls', 'coed'].map((gender) {
                      return ChoiceChip(
                        label: Text(gender.toUpperCase()),
                        selected: _selectedGender == gender,
                        onSelected: (val) => setModalState(() => _selectedGender = val ? gender : null),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AnalyticsTracker.trackSearchPerformed({'type': _selectedType, 'gender': _selectedGender});
                        ref.read(searchAccommodationsProvider.notifier).search(
                          type: _selectedType,
                          gender: _selectedGender,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchAccommodationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
          )
        ],
      ),
      body: searchState.when(
        data: (accommodations) {
          if (accommodations.isEmpty) {
            return const Center(child: Text('No accommodations found.'));
          }
          return ListView.builder(
            itemCount: accommodations.length,
            itemBuilder: (context, index) {
              final acc = accommodations[index];
              return ListTile(
                leading: const Icon(Icons.home, color: AppTheme.brandPrimary),
                title: Text(acc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('₹${acc.startingPrice.toInt()} • ${acc.type}'),
                onTap: () {
                  AnalyticsTracker.trackViewAccommodation(acc.id, acc.name);
                  context.push('/accommodations/${acc.slug}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }
}
