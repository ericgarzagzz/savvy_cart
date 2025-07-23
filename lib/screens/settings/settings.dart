import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:savvy_cart/providers/providers.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final versionAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text("SavvyCart settings")),
      body: SettingsList(
        platform: DevicePlatform.android,
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(
            context,
          ).textTheme.bodyMedium?.color,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: Theme.of(context).cardColor,
          titleTextColor: Theme.of(context).textTheme.headlineSmall?.color,
          settingsTileTextColor: Theme.of(context).textTheme.bodyLarge?.color,
          tileDescriptionTextColor: Theme.of(
            context,
          ).textTheme.bodyMedium?.color,
        ),
        sections: [
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
                      : 'Not configured',
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
                onPressed: (context) =>
                    context.push('/settings/data-management'),
              ),
            ],
          ),
          if (kDebugMode)
            SettingsSection(
              title: Text('Developer'),
              tiles: [
                SettingsTile.navigation(
                  leading: Icon(Icons.data_usage),
                  title: Text('Generate Mock Data'),
                  value: Text('Add sample shopping lists'),
                  onPressed: (context) =>
                      _showGenerateMockDataDialog(context, ref),
                ),
                SettingsTile.navigation(
                  leading: Icon(Icons.delete_forever),
                  title: Text('Delete Database'),
                  value: Text('Clear all data'),
                  onPressed: (context) =>
                      _showDeleteDatabaseDialog(context, ref),
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
                  value: Text(
                    '${packageInfo.version} (${packageInfo.buildNumber})',
                  ),
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

  void _showGenerateMockDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate Mock Data'),
        content: Text(
          'This will create sample shopping lists with items across the year for analytics testing. This may take a few moments.',
        ),
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
                await ref.read(developerProvider.notifier).generateMockData();
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

  void _showDeleteDatabaseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Database'),
        content: Text(
          'This will permanently delete all your data including shopping lists, items, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(developerProvider.notifier).purgeDatabase();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Database deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting database: $e')),
                  );
                }
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
}
