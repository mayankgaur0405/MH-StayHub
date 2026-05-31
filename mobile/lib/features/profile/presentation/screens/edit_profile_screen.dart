import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/analytics_tracker.dart';
import '../../../../core/utils/loading/full_screen_loader.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    AnalyticsTracker.trackEditProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final updateState = ref.watch(updateProfileProvider);

    // Pre-fill controllers once data arrives
    if (!_initialized) {
      profileAsync.whenData((user) {
        _nameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        _initialized = true;
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.brandPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 48, color: AppTheme.brandPrimary),
                  ),
                ),
                const SizedBox(height: 32),

                const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Enter your full name'),
                ),
                const SizedBox(height: 24),

                const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Enter your email'),
                ),
                const SizedBox(height: 12),

                // Phone (read-only)
                profileAsync.whenOrNull(
                  data: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        controller: TextEditingController(text: user.phone),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.lock_outline, size: 18),
                        ),
                      ),
                    ],
                  ),
                ) ?? const SizedBox.shrink(),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateState is AsyncLoading ? null : () async {
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();

                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Name cannot be empty')),
                        );
                        return;
                      }

                      final success = await ref.read(updateProfileProvider.notifier).update(
                        name: name,
                        email: email.isNotEmpty ? email : null,
                      );

                      if (mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully! ✅')),
                        );
                        context.pop();
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
          if (updateState is AsyncLoading)
            const FullScreenLoader(message: 'Updating profile...'),
        ],
      ),
    );
  }
}
