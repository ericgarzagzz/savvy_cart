import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ImportDialog extends ConsumerStatefulWidget {
  final BackupFileInfo backup;

  const ImportDialog({super.key, required this.backup});

  @override
  ConsumerState<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<ImportDialog> {
  ImportOptions _options = const ImportOptions(replaceExisting: true);
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy \'at\' HH:mm');

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.restoreBackup),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.backupInformation,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        '${AppLocalizations.of(context)!.file}:',
                        widget.backup.fileName
                            .replaceAll('manual_backup_', '')
                            .replaceAll('.json', ''),
                      ),
                      _buildInfoRow(
                        '${AppLocalizations.of(context)!.created}:',
                        dateFormat.format(widget.backup.createdDate),
                      ),
                      _buildInfoRow(
                        '${AppLocalizations.of(context)!.size}:',
                        widget.backup.formattedSize,
                      ),
                      _buildInfoRow(
                        '${AppLocalizations.of(context)!.includesSettings}:',
                        widget.backup.includesSettings
                            ? AppLocalizations.of(context)!.yes
                            : AppLocalizations.of(context)!.no,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.importOptions,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.replaceExistingData),
                subtitle: Text(
                  AppLocalizations.of(
                    context,
                  )!.clearAllCurrentDataBeforeImporting,
                ),
                value: _options.replaceExisting,
                onChanged: (value) => setState(() {
                  _options = _options.copyWith(replaceExisting: value ?? true);
                }),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 20,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.important,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _options.replaceExisting
                                ? AppLocalizations.of(
                                    context,
                                  )!.dataReplacementWarning
                                : AppLocalizations.of(
                                    context,
                                  )!.dataMergeWarning,
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isImporting ? null : _performImport,
          style: ElevatedButton.styleFrom(
            backgroundColor: _options.replaceExisting
                ? Theme.of(context).colorScheme.error
                : null,
            foregroundColor: _options.replaceExisting
                ? Theme.of(context).colorScheme.onError
                : null,
          ),
          child: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.restore),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _invalidateAllProviders() {
    // Invalidate all data providers to refresh cached state
    ref.invalidate(shopListCollectionProvider);
    ref.invalidate(getShopListByIdProvider);
    ref.invalidate(shopListItemsProvider);
    ref.invalidate(getShopListItemsProvider);
    ref.invalidate(shopListItemStatsProvider);
    ref.invalidate(chatMessagesProvider);
    ref.invalidate(searchResultsProvider);
  }

  void _performImport() async {
    setState(() {
      _isImporting = true;
    });

    try {
      final backupService = AutoBackupService();
      await backupService.restoreFromBackup(
        widget.backup.filePath,
        replaceExisting: _options.replaceExisting,
      );

      if (mounted) {
        // Invalidate all Riverpod providers to refresh the UI with restored data
        _invalidateAllProviders();

        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            title: Text(AppLocalizations.of(context)!.restoreSuccessful),
            content: Text(
              _options.replaceExisting
                  ? AppLocalizations.of(
                      context,
                    )!.dataRestoredSuccessfullyMessage
                  : AppLocalizations.of(
                      context,
                    )!.backupDataMergedSuccessfullyMessage,
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.done),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.restoreFailed(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
