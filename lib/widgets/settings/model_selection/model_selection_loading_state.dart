import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ModelSelectionLoadingState extends StatelessWidget {
  const ModelSelectionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.loadingAvailableModels),
        ],
      ),
    );
  }
}
