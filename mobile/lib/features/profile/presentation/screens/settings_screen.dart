import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Legal Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
            child: Text('Legal', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _openUrl('https://mhstayhub.com/privacy'),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () => _openUrl('https://mhstayhub.com/terms'),
          ),

          const SizedBox(height: 16),

          // Support Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text('Support', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          _SettingsTile(
            icon: Icons.headset_mic_outlined,
            title: 'Contact Support',
            onTap: () => _openUrl('https://mhstayhub.com/contact'),
          ),

          const SizedBox(height: 32),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: const BorderSide(color: AppTheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          AnalyticsTracker.trackLogout();
                          ref.read(authControllerProvider.notifier).logout();
                          context.go('/login');
                        },
                        child: const Text('Logout', style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // App Version
          const Center(
            child: Text('MH StayHub v1.0.0', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textPrimary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
