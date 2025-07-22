import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savvy_cart/widgets/widgets.dart';

class AiSettingsScreen extends ConsumerWidget {
  const AiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AiSettingsHeader(),
            SizedBox(height: 24),
            ApiConfigurationSection(),
            SizedBox(height: 24),
            ConnectionStatusSection(),
            SizedBox(height: 24),
            GeminiInfoSection(),
          ],
        ),
      ),
    );
  }
}
