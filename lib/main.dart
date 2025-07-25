import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:json_theme/json_theme.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/router.dart';

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

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(ProviderScope(child: MyApp(theme: theme)));
}

class MyApp extends ConsumerWidget {
  final ThemeData theme;

  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageSettingsProvider);
    final selectedLanguage = languageState.settings.selectedLanguage;

    // Determine the locale to use
    const supportedLocales = [
      Locale('en'), // English
      Locale('es'), // Spanish
      Locale('ru'), // Russian
      Locale('pt'), // Portuguese
    ];

    Locale? locale;
    String intlLocale;
    if (selectedLanguage == AppLanguage.system) {
      // Use system locale resolution (null means system default)
      locale = null;
      intlLocale = Intl.getCurrentLocale();
    } else {
      final preferredLocale = selectedLanguage.locale;
      // Check if the selected language is supported
      final isSupported = supportedLocales.any(
        (supported) => supported.languageCode == preferredLocale?.languageCode,
      );

      if (isSupported && preferredLocale != null) {
        locale = preferredLocale;
        intlLocale = selectedLanguage.code;
      } else {
        // Fallback to English if not supported
        locale = const Locale('en');
        intlLocale = 'en';
      }
    }

    // Update Intl default locale
    Intl.defaultLocale = intlLocale;
    return MaterialApp.router(
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('ru'), // Russian
        Locale('pt'), // Portuguese
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if current locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // Fallback to English
        return const Locale('en');
      },
    );
  }
}
