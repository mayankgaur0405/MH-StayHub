import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/discovery_providers.dart';

class CollegeDetailsScreen extends ConsumerWidget {
  final String slug;
  // Note: The collegeId should ideally be fetched using the slug first if backend doesn't support fetching accommodations by college slug directly.
  // For the sake of this UI, we will assume we have the college details fetched.
  const CollegeDetailsScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A FutureProvider that fetches the college by slug and its accommodations would be used here.
    return Scaffold(
      appBar: AppBar(title: Text('Near $slug')),
      body: const Center(
        child: Text('College Details & Accommodations (To be fully wired)'),
      ),
    );
  }
}
