import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/share_utils.dart';
import '../../../../core/utils/errors/error_view.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../../../leads/presentation/providers/saved_accommodation_provider.dart';
import '../providers/accommodation_details_provider.dart';

class AccommodationDetailsScreen extends ConsumerStatefulWidget {
  final String slug;

  const AccommodationDetailsScreen({super.key, required this.slug});

  @override
  ConsumerState<AccommodationDetailsScreen> createState() => _AccommodationDetailsScreenState();
}

class _AccommodationDetailsScreenState extends ConsumerState<AccommodationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(accommodationDetailsProvider(widget.slug));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final bgColor = isDark ? AppTheme.backgroundDark : AppTheme.background;
    final surfaceColor = isDark ? AppTheme.surfaceDark : AppTheme.surface;
    final surfaceAlt = isDark ? AppTheme.surfaceAltDark : AppTheme.surfaceAlt;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.border;
    final textColor = isDark ? AppTheme.foregroundDark : AppTheme.foreground;
    final mutedColor = isDark ? AppTheme.mutedDark : AppTheme.muted;

    return Scaffold(
      backgroundColor: bgColor,
      body: detailsAsync.when(
        data: (acc) {
          return CustomScrollView(
            slivers: [
              // ─── Image Carousel App Bar ──────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: surfaceColor,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    onPressed: () => ShareUtils.nativeShare(acc.slug, acc.name, acc.id),
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      return IconButton(
                        icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                        onPressed: () {
                          ref.read(savedAccommodationsProvider.notifier).save(acc.id);
                          AnalyticsTracker.trackSaveProperty(acc.id, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Saved to favorites!'),
                              backgroundColor: AppTheme.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                            )
                          );
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
                                placeholder: (context, url) => Container(
                                  color: surfaceAlt,
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: surfaceAlt,
                                  child: const Icon(Icons.error_outline_rounded, color: AppTheme.danger),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          color: surfaceAlt,
                          child: Icon(Icons.apartment_rounded, size: 64, color: mutedColor.withOpacity(0.5)),
                        ),
                      
                      // Gradient overlay for back button visibility
                      Positioned(
                        top: 0, left: 0, right: 0, height: 100,
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
                          bottom: 16, right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.photo_library_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '1 / ${acc.images.length}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ─── Content ─────────────────────────────────────────────
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
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: Text(
                              acc.type.toUpperCase(),
                              style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: surfaceAlt,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: Text(
                              acc.gender.toUpperCase(),
                              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Spacer(),
                          if (acc.verificationStatus != 'unverified')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_rounded, color: AppTheme.success, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    acc.verificationStatus == 'premium_verified' ? 'Premium' : 'Verified',
                                    style: const TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        acc.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded, color: mutedColor, size: 18),
                          const SizedBox(width: 4),
                          Expanded(child: Text(acc.address, style: TextStyle(color: mutedColor, fontSize: 14))),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // ─── Pricing Card ────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                          ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Starting from', style: TextStyle(color: mutedColor, fontSize: 13)),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '₹${acc.startingPrice.toInt()}',
                                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.brandPrimary, letterSpacing: -0.5),
                                    ),
                                    Text('/month', style: TextStyle(color: mutedColor, fontSize: 14, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                if (acc.deposit != null) ...[
                                  const SizedBox(height: 4),
                                  Text('Security Deposit: ₹${acc.deposit?.toInt()}', style: TextStyle(fontSize: 12, color: mutedColor)),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ─── Amenities ───────────────────────────────────
                      Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: acc.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: surfaceAlt,
                              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.brandPrimary),
                                const SizedBox(width: 8),
                                Text(amenity, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // ─── Description ─────────────────────────────────
                      if (acc.description != null) ...[
                        Text('About this property', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                        const SizedBox(height: 12),
                        Text(acc.description!, style: TextStyle(color: mutedColor, height: 1.6, fontSize: 14)),
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
      
      // ─── Bottom Owner Actions Bar ────────────────────────────────────
      bottomNavigationBar: detailsAsync.whenOrNull(
        data: (acc) {
          final phone = acc.ownerContact?['phone'];
          final name = acc.ownerContact?['name'] ?? 'Owner';
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(top: BorderSide(color: borderColor)),
              boxShadow: [
                BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
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
                            backgroundColor: AppTheme.brandAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                          ),
                          onPressed: () {
                            context.push('/priority-hold', extra: {'id': acc.id, 'name': acc.name});
                          },
                          child: const Text('Priority Hold', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                          ),
                          onPressed: () {
                            context.push('/schedule-visit', extra: {'id': acc.id, 'name': acc.name});
                          },
                          child: const Text('Schedule Visit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.brandPrimary,
                            side: BorderSide(color: borderColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                          ),
                          icon: const Icon(Icons.phone_rounded, size: 18),
                          label: const Text('Call', style: TextStyle(fontWeight: FontWeight.w600)),
                          onPressed: phone != null ? () => ShareUtils.callOwner(phone, acc.id) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.success,
                            side: BorderSide(color: borderColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                          ),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                          label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.w600)),
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
