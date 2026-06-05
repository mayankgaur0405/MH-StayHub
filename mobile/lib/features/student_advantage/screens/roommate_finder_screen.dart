import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_hub_providers.dart';

class RoommateFinderScreen extends ConsumerWidget {
  const RoommateFinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profilesAsync = ref.watch(roommateProfilesProvider);

    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC);
    final cardColor = isDark ? const Color(0xFF131825) : Colors.white;
    final borderColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC);
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Roommate Finder', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_alt_outlined, size: 64, color: mutedColor),
                  const SizedBox(height: 16),
                  Text('No roommate profiles yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text('Be the first to create your profile!', style: TextStyle(color: mutedColor)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create My Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C3CE1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(roommateProfilesProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final foodPref = profile['foodPreference'] ?? 'any';
                final sleepSchedule = profile['sleepSchedule'] ?? 'flexible';

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
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF6C3CE1).withOpacity(0.1),
                              child: const Icon(Icons.person, color: Color(0xFF6C3CE1)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile['college'] ?? 'Unknown College',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
                                  ),
                                  Text(
                                    '${profile['yearOfStudy'] ?? ''} Year',
                                    style: TextStyle(fontSize: 13, color: mutedColor),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '₹${profile['budget'] ?? 0}/mo',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF10B981)),
                              ),
                            ),
                          ],
                        ),
                        if (profile['bio'] != null && (profile['bio'] as String).isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            profile['bio'],
                            style: TextStyle(color: mutedColor, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildTag(foodPref == 'veg' ? '🥦 Veg' : foodPref == 'non-veg' ? '🍗 Non-Veg' : '🍽️ Any', borderColor, textColor),
                            _buildTag(sleepSchedule == 'early_bird' ? '🌅 Early Bird' : sleepSchedule == 'night_owl' ? '🦉 Night Owl' : '⏰ Flexible', borderColor, textColor),
                            if (profile['smoking'] == true) _buildTag('🚬 Smokes', borderColor, textColor),
                            if (profile['drinking'] == true) _buildTag('🍺 Drinks', borderColor, textColor),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message_rounded, size: 18),
                            label: const Text('Connect'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF6C3CE1),
                              side: const BorderSide(color: Color(0xFF6C3CE1)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
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
              Text('Could not load profiles', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => ref.invalidate(roommateProfilesProvider), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }
}
