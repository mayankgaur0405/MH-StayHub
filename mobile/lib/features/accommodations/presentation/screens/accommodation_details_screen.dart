import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/share_utils.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/accommodation_details_provider.dart';

class AccommodationDetailsScreen extends ConsumerStatefulWidget {
  final String slug;

  const AccommodationDetailsScreen({super.key, required this.slug});

  @override
  ConsumerState<AccommodationDetailsScreen> createState() => _AccommodationDetailsScreenState();
}

class _AccommodationDetailsScreenState extends ConsumerState<AccommodationDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Pre-fetch/Analytics could be triggered here if needed
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(accommodationDetailsProvider(widget.slug));

    return Scaffold(
      body: detailsAsync.when(
        data: (acc) {
          return CustomScrollView(
            slivers: [
              // Image Carousel App Bar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      ShareUtils.nativeShare(acc.slug, acc.name, acc.id);
                    },
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      return IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // This interacts with SavedAccommodationProvider
                          // Using a Consumer to get ref locally
                          ref.read(savedAccommodationsProvider.notifier).save(acc.id);
                          AnalyticsTracker.trackSaveProperty(acc.id, true);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to favorites!')));
                        },
                      );
                    }
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (acc.images.isNotEmpty)
                        GestureDetector(
                          onTap: () => context.push('/gallery', extra: acc.images),
                          child: PageView.builder(
                            itemCount: acc.images.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: acc.images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              );
                            },
                          ),
                        )
                      else
                        Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 64, color: Colors.grey)),
                      
                      // Gradient overlay for back button visibility
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                      
                      // Photos count badge
                      if (acc.images.length > 1)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '1 / ${acc.images.length} Photos',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.brandPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(acc.type.toUpperCase(), style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(acc.gender.toUpperCase(), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          if (acc.verificationStatus != 'unverified')
                            Row(
                              children: [
                                const Icon(Icons.verified, color: AppTheme.success, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  acc.verificationStatus == 'premium_verified' ? 'Premium' : 'Verified',
                                  style: const TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(acc.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.textSecondary, size: 18),
                          const SizedBox(width: 4),
                          Expanded(child: Text(acc.address, style: const TextStyle(color: AppTheme.textSecondary))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pricing Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, spreadRadius: 0)
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Starts from', style: TextStyle(color: AppTheme.textSecondary)),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('₹${acc.startingPrice.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
                                    const Text('/month', style: TextStyle(color: AppTheme.textSecondary)),
                                  ],
                                ),
                                if (acc.deposit != null) ...[
                                  const SizedBox(height: 4),
                                  Text('Deposit: ₹${acc.deposit?.toInt()}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Amenities
                      const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: acc.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(amenity, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Description
                      if (acc.description != null) ...[
                        const Text('About this property', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(acc.description!, style: const TextStyle(color: AppTheme.textSecondary, height: 1.5)),
                        const SizedBox(height: 32),
                      ],

                      const SizedBox(height: 100), // Padding for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: FullScreenLoader()),
        error: (err, stack) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(message: 'Failed to load details', onRetry: () => ref.invalidate(accommodationDetailsProvider(widget.slug))),
        ),
      ),
      
      // Bottom Owner Actions Bar
      bottomNavigationBar: detailsAsync.whenOrNull(
        data: (acc) {
          final phone = acc.ownerContact?['phone'];
          final name = acc.ownerContact?['name'] ?? 'Owner';
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            context.push('/priority-hold', extra: {'id': acc.id, 'name': acc.name});
                          },
                          child: const Text('Priority Hold', style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            context.push('/schedule-visit', extra: {'id': acc.id, 'name': acc.name});
                          },
                          child: const Text('Schedule Visit', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Owner'),
                          onPressed: phone != null ? () => ShareUtils.callOwner(phone, acc.id) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                          icon: const Icon(Icons.chat),
                          label: const Text('WhatsApp'),
                          onPressed: phone != null ? () => ShareUtils.whatsappOwner(phone, name, acc.id) : null,
                        ),
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
  }
}
