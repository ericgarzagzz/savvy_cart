import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/services/services.dart';

final themeServiceProvider = ChangeNotifierProvider<ThemeService>((ref) {
  return ThemeService();
});

final currentThemeProvider = Provider<ThemeData?>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return themeService.currentTheme;
});

final isDarkModeProvider = Provider<bool>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return themeService.isDarkMode;
});

final themeModeProvider = Provider<AppThemeMode>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return themeService.themeMode;
});