import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/theme_provider.dart';

class CommandCenterScreen extends ConsumerWidget {
  const CommandCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryBrand = const Color(0xFF6C3CE1);
    final secondaryBrand = const Color(0xFF14B8A6);
    final warningColor = const Color(0xFFF59E0B);
    final surfaceColor = isDark ? const Color(0xFF131825) : Colors.white;
    final textColor = isDark ? const Color(0xFFF1F3F8) : const Color(0xFF111827);
    final mutedTextColor = isDark ? const Color(0xFF8B95A8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          'Student Command Center',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: mutedTextColor),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: mutedTextColor),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Student!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            Text('Manage your MH StayHub experience', style: TextStyle(fontSize: 16, color: mutedTextColor)),
            const SizedBox(height: 24),

            // Verification Card
            _buildVerificationCard(surfaceColor, isDark, warningColor, textColor, mutedTextColor, context),
            
            const SizedBox(height: 32),
            Text('Quick Access', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            
            // Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildModernCard('Advantage', Icons.local_offer_rounded, primaryBrand, surfaceColor, textColor, mutedTextColor, isDark, () => context.push('/advantage')),
                _buildModernCard('Career Hub', Icons.work_rounded, secondaryBrand, surfaceColor, textColor, mutedTextColor, isDark, () => context.push('/career-hub')),
                _buildModernCard('Roommates', Icons.people_alt_rounded, warningColor, surfaceColor, textColor, mutedTextColor, isDark, () => context.push('/roommates')),
                _buildModernCard('Marketplace', Icons.storefront_rounded, Colors.green, surfaceColor, textColor, mutedTextColor, isDark, () => context.push('/marketplace')),
                _buildModernCard('Seniors', Icons.forum_rounded, Colors.blue, surfaceColor, textColor, mutedTextColor, isDark, () => context.push('/senior-connect')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard(Color surfaceColor, bool isDark, Color warningColor, Color textColor, Color mutedTextColor, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: warningColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.shield_outlined, color: warningColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification Pending', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                const SizedBox(height: 4),
                Text('Unlock exclusive deals.', style: TextStyle(color: mutedTextColor, fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: mutedTextColor, size: 16),
        ],
      ),
    );
  }

  Widget _buildModernCard(String title, IconData icon, Color brandColor, Color surfaceColor, Color textColor, Color mutedColor, bool isDark, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF252D3D) : const Color(0xFFE2E5EC)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: brandColor.withOpacity(0.1),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: brandColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, size: 28, color: brandColor),
                ),
                const Spacer(),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward, color: mutedColor, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
