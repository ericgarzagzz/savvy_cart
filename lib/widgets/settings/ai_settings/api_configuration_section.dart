import 'package:flutter/material.dart';

import 'package:savvy_cart/widgets/widgets.dart';

class ApiConfigurationSection extends StatelessWidget {
  const ApiConfigurationSection({super.key});

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
