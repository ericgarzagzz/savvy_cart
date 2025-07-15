import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeService extends ChangeNotifier with WidgetsBindingObserver {
  static const String _themeModeKey = 'theme_mode';
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  AppThemeMode _themeMode = AppThemeMode.system;
  Brightness _systemBrightness = Brightness.light;

  ThemeData? get lightTheme => _lightTheme;
  ThemeData? get darkTheme => _darkTheme;
  AppThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark;
    }
  }

  ThemeData? get currentTheme {
    if (isDarkMode) {
      return _darkTheme;
    } else {
      return _lightTheme;
    }
  }

  Future<void> initialize() async {
    // Add observer for system theme changes
    WidgetsBinding.instance.addObserver(this);
    
    // Get initial system brightness
    _systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    await _loadThemes();
    await _loadThemeMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final newBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (_systemBrightness != newBrightness) {
      _systemBrightness = newBrightness;
      // Only notify if we're in system mode
      if (_themeMode == AppThemeMode.system) {
        notifyListeners();
      }
    }
    super.didChangePlatformBrightness();
  }

  Future<void> _loadThemes() async {
    try {
      final themeStr = await rootBundle.loadString("assets/appainter_theme.json");
      final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;

      if (themeJson.containsKey('light')) {
        _lightTheme = ThemeDecoder.decodeThemeData(themeJson['light'])?.copyWith(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              for (var platform in TargetPlatform.values)
                platform: FadeForwardsPageTransitionsBuilder()
            },
          )
        );
      }

      if (themeJson.containsKey('dark')) {
        _darkTheme = ThemeDecoder.decodeThemeData(themeJson['dark'])?.copyWith(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              for (var platform in TargetPlatform.values)
                platform: FadeForwardsPageTransitionsBuilder()
            },
          )
        );
      }
      
      // Fallback to default themes if decoding fails
      _lightTheme ??= ThemeData.light();
      _darkTheme ??= ThemeData.dark();
    } catch (e) {
      debugPrint('Error loading themes: $e');
      // Fallback to default themes
      _lightTheme = ThemeData.light();
      _darkTheme = ThemeData.dark();
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeModeKey);
      if (themeModeString != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => AppThemeMode.system,
        );
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_themeModeKey, mode.toString());
      } catch (e) {
        debugPrint('Error saving theme mode: $e');
      }
    }
  }

  String getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
}

class FadeForwardsPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}