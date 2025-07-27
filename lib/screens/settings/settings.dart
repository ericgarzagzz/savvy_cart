import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final versionAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
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
            title: Text(AppLocalizations.of(context).aiAssistant),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.auto_awesome),
                title: Text(AppLocalizations.of(context).aiSettings),
                value: Text(
                  aiSettingsState.hasValidApiKey
                      ? AppLocalizations.of(context).ready
                      : aiSettingsState.settings.apiKey.isNotEmpty
                      ? AppLocalizations.of(context).notVerified
                      : AppLocalizations.of(context).notConfigured,
                ),
                onPressed: (context) => context.push('/settings/ai'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context).data),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.backup),
                title: Text(AppLocalizations.of(context).backupAndRestore),
                value: Text(AppLocalizations.of(context).manageBackups),
                onPressed: (context) =>
                    context.push('/settings/data-management'),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context).localization),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(AppLocalizations.of(context).language),
                value: Consumer(
                  builder: (context, ref, child) {
                    final languageState = ref.watch(languageSettingsProvider);
                    return Text(
                      AppLanguage.getLocalizedDisplayName(
                        AppLocalizations.of(context),
                        languageState.settings.selectedLanguage,
                      ),
                    );
                  },
                ),
                onPressed: (context) => context.push('/settings/language'),
              ),
            ],
          ),
          if (kDebugMode)
            SettingsSection(
              title: Text(AppLocalizations.of(context).developer),
              tiles: [
                SettingsTile.navigation(
                  leading: Icon(Icons.data_usage),
                  title: Text(AppLocalizations.of(context).generateMockData),
                  value: Text(
                    AppLocalizations.of(context).addSampleShoppingLists,
                  ),
                  onPressed: (context) =>
                      _showGenerateMockDataDialog(context, ref),
                ),
                SettingsTile.navigation(
                  leading: Icon(Icons.delete_forever),
                  title: Text(AppLocalizations.of(context).deleteDatabase),
                  value: Text(AppLocalizations.of(context).clearAllData),
                  onPressed: (context) =>
                      _showDeleteDatabaseDialog(context, ref),
                ),
              ],
            ),
          SettingsSection(
            title: Text(AppLocalizations.of(context).about),
            tiles: [
              versionAsync.when(
                data: (packageInfo) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(AppLocalizations.of(context).version),
                  value: Text(
                    '${packageInfo.version} (${packageInfo.buildNumber})',
                  ),
                ),
                loading: () => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(AppLocalizations.of(context).version),
                  value: Text(AppLocalizations.of(context).loading),
                ),
                error: (_, __) => SettingsTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(AppLocalizations.of(context).version),
                  value: Text(AppLocalizations.of(context).version),
                ),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.article),
                title: Text(AppLocalizations.of(context).licenses),
                onPressed: (context) => context.push('/settings/licenses'),
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
        title: Text(AppLocalizations.of(context).generateMockData),
        content: Text(
          AppLocalizations.of(context).mockDataGenerationDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).generatingMockData,
                    ),
                  ),
                );
                await ref.read(developerProvider.notifier).generateMockData();
                if (context.mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        ).mockDataGeneratedSuccessfully,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        ).errorGeneratingMockData(e.toString()),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context).generate),
          ),
        ],
      ),
    );
  }

  void _showDeleteDatabaseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteDatabase),
        content: Text(AppLocalizations.of(context).databaseDeletionWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(developerProvider.notifier).purgeDatabase();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        ).databaseDeletedSuccessfully,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        ).errorDeletingDatabase(e.toString()),
                      ),
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }
}
