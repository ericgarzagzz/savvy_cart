import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final themeService = ref.watch(themeServiceProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final versionAsync = ref.watch(packageInfoProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("SavvyCart settings"),
      ),
      body: SettingsList(
        platform: DevicePlatform.android,
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        sections: [
          SettingsSection(
            title: Text('Appearance'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.palette),
                title: Text('Theme'),
                value: Text('Current: ${themeService.getThemeModeDisplayName(currentThemeMode)}'),
                onPressed: (context) => _showThemeDialog(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: Text('AI Assistant'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.auto_awesome),
                title: Text('AI Settings'),
                value: Text(
                  aiSettingsState.hasValidApiKey
                    ? 'Ready'
                    : aiSettingsState.settings.apiKey.isNotEmpty
                        ? 'Not verified'
                        : 'Not configured'
                ),
                onPressed: (context) => context.push('/settings/ai'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Data'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.backup),
                title: Text('Backup & Restore'),
                value: Text('Manage backups'),
                onPressed: (context) => context.push('/settings/data-management'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              versionAsync.when(
                data: (packageInfo) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('${packageInfo.version} (${packageInfo.buildNumber})'),
                ),
                loading: () => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('Loading...'),
                ),
                error: (_, __) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  value: Text('1.0.0+1'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeService = ref.read(themeServiceProvider);
    final currentThemeMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(themeService.getThemeModeDisplayName(mode)),
              subtitle: Text(_getThemeModeDescription(mode)),
              value: mode,
              groupValue: currentThemeMode,
              onChanged: (AppThemeMode? value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system setting';
    }
  }
}
