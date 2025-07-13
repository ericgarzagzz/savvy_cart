import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:savvy_cart/providers/settings_providers.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
