import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:savvy_cart/database_helper.dart';
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
          if (kDebugMode) SettingsSection(
            title: Text('Developer'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.data_usage),
                title: Text('Generate Mock Data'),
                value: Text('Add sample shopping lists'),
                onPressed: (context) => _showGenerateMockDataDialog(context),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.delete_forever),
                title: Text('Delete Database'),
                value: Text('Clear all data'),
                onPressed: (context) => _showDeleteDatabaseDialog(context),
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


  void _showGenerateMockDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate Mock Data'),
        content: Text('This will create sample shopping lists with items across the year for analytics testing. This may take a few moments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  SnackBar(content: Text('Generating mock data...')),
                );
                await DatabaseHelper.instance.generateMockData();
                messenger.showSnackBar(
                  SnackBar(content: Text('Mock data generated successfully!')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Error generating mock data: $e')),
                );
              }
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDatabaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Database'),
        content: Text('This will permanently delete all your data including shopping lists, items, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await DatabaseHelper.instance.purgeDatabase();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Database deleted successfully')),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting database: $e')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
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
