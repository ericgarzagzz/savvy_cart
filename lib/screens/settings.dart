import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/widgets/settings/ai_settings_form.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text("AI Settings", style: Theme.of(context).textTheme.titleLarge),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: AiSettingsForm(),
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
