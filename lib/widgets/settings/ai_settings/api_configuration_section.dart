import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ApiConfigurationSection extends StatelessWidget {
  const ApiConfigurationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).apiConfiguration,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).setupGeminiApiKeyDescription,
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
