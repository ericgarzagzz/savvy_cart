import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final themeService = ref.watch(themeServiceProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("SavvyCart settings"),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appearance", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.palette),
                      title: Text('Theme'),
                      subtitle: Text('Current: ${themeService.getThemeModeDisplayName(currentThemeMode)}'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _showThemeDialog(context, ref),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text("AI Assistant", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.auto_awesome),
                      title: Text('AI Settings'),
                      subtitle: Text(
                        aiSettingsState.hasValidApiKey
                          ? 'Connected and ready'
                          : aiSettingsState.settings.apiKey.isNotEmpty
                              ? 'Not verified'
                              : 'Configure Gemini API key'
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (aiSettingsState.hasValidApiKey)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Ready',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () => context.push('/settings/ai'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text("Data", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.backup),
                      title: Text('Backup & Restore'),
                      subtitle: Text('Manage automatic and manual backups'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => context.push('/settings/data-management'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text("About", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Card(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final versionAsync = ref.watch(packageInfoProvider);
                        return versionAsync.when(
                          data: (packageInfo) => ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Version'),
                            subtitle: Text('${packageInfo.version} (${packageInfo.buildNumber})'),
                          ),
                          loading: () => ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Version'),
                            subtitle: Text('Loading...'),
                          ),
                          error: (_, __) => ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Version'),
                            subtitle: Text('1.0.0+1'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
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
