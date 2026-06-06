import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
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
  bool _nearMeActive = false;
  double? _userLat;
  double? _userLng;
  bool _gettingLocation = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(searchAccommodationsProvider.notifier).search());
  }

  Future<void> _toggleNearMe() async {
    if (_nearMeActive) {
      // Turn off Near Me
      setState(() {
        _nearMeActive = false;
        _userLat = null;
        _userLng = null;
      });
      _performSearch();
      return;
    }

    setState(() => _gettingLocation = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        setState(() => _gettingLocation = false);
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          setState(() => _gettingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission permanently denied. Please enable in Settings.')),
          );
        }
        setState(() => _gettingLocation = false);
        return;
      }

      // Get the position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );

      setState(() {
        _userLat = position.latitude;
        _userLng = position.longitude;
        _nearMeActive = true;
        _gettingLocation = false;
      });

      _performSearch();
    } catch (e) {
      setState(() => _gettingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    }
  }

  void _performSearch() {
    AnalyticsTracker.trackSearchPerformed({
      'type': _selectedType,
      'gender': _selectedGender,
      'nearMe': _nearMeActive,
    });
    ref.read(searchAccommodationsProvider.notifier).search(
      type: _selectedType,
      gender: _selectedGender,
      lat: _userLat,
      lng: _userLng,
      radius: _nearMeActive ? 5000 : null,
    );
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
                        _performSearch();
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
      body: Column(
        children: [
          // Near Me button bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _gettingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : ActionChip(
                        avatar: Icon(
                          Icons.my_location,
                          size: 18,
                          color: _nearMeActive ? Colors.white : AppTheme.brandPrimary,
                        ),
                        label: Text(
                          _nearMeActive ? 'Near Me ✓' : 'Near Me',
                          style: TextStyle(
                            color: _nearMeActive ? Colors.white : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: _nearMeActive ? AppTheme.brandPrimary : null,
                        onPressed: _toggleNearMe,
                      ),
                if (_nearMeActive) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Within 5 km',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Results
          Expanded(
            child: searchState.when(
              data: (accommodations) {
                if (accommodations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppTheme.muted.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text('No accommodations found.'),
                        if (_nearMeActive)
                          TextButton(
                            onPressed: _toggleNearMe,
                            child: const Text('Clear "Near Me" filter'),
                          ),
                      ],
                    ),
                  );
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
          ),
        ],
      ),
    );
  }
}
