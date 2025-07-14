import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/router.dart';
import 'package:savvy_cart/providers/theme_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final systemCurrentLocale = await findSystemLocale();
  Intl.defaultLocale = systemCurrentLocale;

  runApp(
    ProviderScope(
      child: MyApp(),
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeService = ref.watch(themeServiceProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    // Initialize theme service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (themeService.lightTheme == null || themeService.darkTheme == null) {
        themeService.initialize();
      }
    });

    return MaterialApp.router(
      theme: themeService.lightTheme,
      darkTheme: themeService.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
