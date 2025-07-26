import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageSettingsProvider);
    final selectedLanguage = languageState.settings.selectedLanguage;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).selectLanguage)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: AppLanguage.values.map((language) {
                  final isSelected = selectedLanguage == language;
                  final isComingSoon = false;

                  return LanguageTile(
                    language: language,
                    isSelected: isSelected,
                    isDisabled: isComingSoon,
                    isComingSoon: isComingSoon,
                    onTap: isComingSoon
                        ? null
                        : () async {
                            await ref
                                .read(languageSettingsProvider.notifier)
                                .updateLanguage(language);
                          },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
