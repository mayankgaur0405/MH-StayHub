import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  const env = String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: '.env.$env');
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    // ProviderScope is required for Riverpod to work
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MHStayHubApp(),
    ),
  );
}

class MHStayHubApp extends ConsumerWidget {
  const MHStayHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router and theme providers
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'MH StayHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
