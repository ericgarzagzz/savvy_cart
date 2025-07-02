import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'package:savvy_cart/router.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final systemCurrentLocale = await findSystemLocale();
  Intl.defaultLocale = systemCurrentLocale;

  final themeStr = await rootBundle.loadString("assets/appainter_theme.json");
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(
    ProviderScope(
      child: MyApp(
          theme: theme.copyWith(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                for (var platform in TargetPlatform.values)
                  platform: FadeForwardsPageTransitionsBuilder()
              },
            )
          )
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({super.key, required this.theme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: router,
    );
  }
}
