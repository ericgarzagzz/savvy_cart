import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ConnectionStatusSection extends StatelessWidget {
  const ConnectionStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.connectionStatus,
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
