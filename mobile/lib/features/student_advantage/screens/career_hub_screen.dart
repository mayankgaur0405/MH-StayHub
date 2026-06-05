import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_hub_providers.dart';

class CareerHubScreen extends ConsumerWidget {
  const CareerHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final eventsAsync = ref.watch(eventsProvider);

    final bgColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC);
    final cardColor = isDark ? const Color(0xFF131825) : Colors.white;
    final borderColor = isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC);
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Career Hub', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          backgroundColor: cardColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          bottom: TabBar(
            indicatorColor: const Color(0xFF6C3CE1),
            labelColor: const Color(0xFF6C3CE1),
            unselectedLabelColor: mutedColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Opportunities', icon: Icon(Icons.work_rounded, size: 20)),
              Tab(text: 'Events', icon: Icon(Icons.event_rounded, size: 20)),
            ],
          ),
        ),
        body: eventsAsync.when(
          data: (events) {
            final placements = events.where((e) => e['type'] == 'placement' || e['type'] == 'internship').toList();
            final otherEvents = events.where((e) => e['type'] != 'placement' && e['type'] != 'internship').toList();

            return TabBarView(
              children: [
                _buildEventList(placements, 'No opportunities yet', 'Placement and internship drives will appear here.', cardColor, borderColor, textColor, mutedColor, isDark, ref),
                _buildEventList(otherEvents, 'No events yet', 'Workshops, hackathons and meetups will appear here.', cardColor, borderColor, textColor, mutedColor, isDark, ref),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: const Color(0xFF6C3CE1))),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: mutedColor),
                const SizedBox(height: 12),
                Text('Could not load events', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: () => ref.invalidate(eventsProvider), child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(
    List<Map<String, dynamic>> events,
    String emptyTitle,
    String emptySubtitle,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color mutedColor,
    bool isDark,
    WidgetRef ref,
  ) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 64, color: mutedColor),
            const SizedBox(height: 16),
            Text(emptyTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text(emptySubtitle, style: TextStyle(color: mutedColor), textAlign: TextAlign.center),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(eventsProvider),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final typeColor = _typeColor(event['type'] ?? '');
          final typeLabel = _typeLabel(event['type'] ?? '');

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
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(typeLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: typeColor)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${event['seats'] ?? 0} seats',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event['title'] ?? 'Untitled Event',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event['description'] ?? '',
                    style: TextStyle(color: mutedColor, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: mutedColor),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(event['date']),
                        style: TextStyle(fontSize: 12, color: mutedColor),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on_outlined, size: 14, color: mutedColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['location'] ?? '',
                          style: TextStyle(fontSize: 12, color: mutedColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C3CE1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'TBD';
    try {
      final d = DateTime.parse(date.toString());
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[d.month - 1]} ${d.day}, ${d.year}';
    } catch (_) {
      return date.toString();
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'placement': return const Color(0xFF6C3CE1);
      case 'internship': return const Color(0xFF14B8A6);
      case 'workshop': return const Color(0xFFF59E0B);
      case 'hackathon': return const Color(0xFFEC4899);
      case 'meetup': return const Color(0xFF3B82F6);
      default: return const Color(0xFF6B7280);
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'placement': return 'PLACEMENT DRIVE';
      case 'internship': return 'INTERNSHIP';
      case 'workshop': return 'WORKSHOP';
      case 'hackathon': return 'HACKATHON';
      case 'meetup': return 'MEETUP';
      default: return type.toUpperCase();
    }
  }
}
