import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';

class BackupInfoSection extends StatelessWidget {
  const BackupInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).howBackupWorks,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BackupInfoPoint(
            text: AppLocalizations.of(
              context,
            ).automaticBackupSyncsToGoogleDrive,
          ),
          _BackupInfoPoint(
            text: AppLocalizations.of(
              context,
            ).manualSnapshotsStoredLocallyAndSynced,
          ),
          _BackupInfoPoint(
            text: AppLocalizations.of(context).restoringWillReplaceCurrentData,
          ),
          _BackupInfoPoint(
            text: AppLocalizations.of(
              context,
            ).backupsIncludeShoppingListsChatAndSettings,
          ),
        ],
      ),
    );
  }
}

class _BackupInfoPoint extends StatelessWidget {
  final String text;

  const _BackupInfoPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
