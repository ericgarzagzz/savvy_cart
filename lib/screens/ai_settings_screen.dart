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
            _ApiConfigurationSection(),
            SizedBox(height: 24),
            _ConnectionStatusSection(),
            SizedBox(height: 24),
            GeminiInfoSection(),
          ],
        ),
      ),
    );
  }
}

class _ApiConfigurationSection extends StatelessWidget {
  const _ApiConfigurationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Configuration',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your Google™ Gemini™ API key to enable AI features',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        const AiSettingsForm(),
      ],
    );
  }
}

class _ConnectionStatusSection extends StatelessWidget {
  const _ConnectionStatusSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connection Status',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const ConnectionStatusCard(),
      ],
    );
  }
}
