import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';

class LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isComingSoon;

  const LanguageTile({
    super.key,
    required this.language,
    required this.isSelected,
    this.onTap,
    this.isDisabled = false,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 3 : 1,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : isDisabled
          ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
          : null,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isDisabled
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ColorFiltered(
                    colorFilter: isDisabled
                        ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                        : const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          ),
                    child: language == AppLanguage.system
                        ? Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: Icon(
                              Icons.auto_awesome,
                              color: isDisabled
                                  ? Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4)
                                  : Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          )
                        : CountryFlag.fromCountryCode(
                            language.countryCode,
                            height: 40,
                            width: 60,
                            shape: RoundedRectangle(4),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLanguage.getLocalizedDisplayName(
                        AppLocalizations.of(context),
                        language,
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : isDisabled
                            ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.4)
                            : null,
                      ),
                    ),
                    if (language == AppLanguage.system) ...[
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).autoDetectFromDeviceSettings,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.9)
                              : isDisabled
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3)
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    if (isComingSoon) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Coming Soon',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected && !isDisabled)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
