import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/router.dart';
import 'package:savvy_cart/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    developer.log(
      'Flutter Error: ${details.exception}',
      name: 'SavvyCart',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  final systemCurrentLocale = await findSystemLocale();
  Intl.defaultLocale = systemCurrentLocale;

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeService = ref.watch(themeServiceProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    // Initialize theme service synchronously if not already initialized
    if (themeService.lightTheme == null || themeService.darkTheme == null) {
      return FutureBuilder(
        future: themeService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp.router(
              theme: themeService.lightTheme ?? ThemeData.light(),
              darkTheme: themeService.darkTheme ?? ThemeData.dark(),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            );
          }

          // Show loading screen while themes are loading
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        },
      );
    }

    return MaterialApp.router(
      theme: themeService.lightTheme ?? ThemeData.light(),
      darkTheme: themeService.darkTheme ?? ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
