import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  const env = String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: '.env.$env');
  
  runApp(
    // ProviderScope is required for Riverpod to work
    const ProviderScope(
      child: MHStayHubApp(),
    ),
  );
}

class MHStayHubApp extends ConsumerWidget {
  const MHStayHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MH StayHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
