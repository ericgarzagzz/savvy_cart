import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/services/services.dart';

class BackupCreateDialog extends StatefulWidget {
  final VoidCallback? onBackupCreated;

  const BackupCreateDialog({super.key, this.onBackupCreated});

  @override
  State<BackupCreateDialog> createState() => _BackupCreateDialogState();
}

class _BackupCreateDialogState extends State<BackupCreateDialog> {
  ExportOptions _options = const ExportOptions(
    includeSettings: true,
    includeShopLists: true, // Always include shopping lists
    includeChatHistory: true,
    includeSuggestions: true,
  );
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.createManualSnapshot),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.shoppingListsAlwaysIncluded,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.chooseAdditionalData),
            const SizedBox(height: 12),
            _buildOptionCheckbox(
              AppLocalizations.of(context)!.settings,
              _options.includeSettings,
              (value) => setState(() {
                _options = _options.copyWith(includeSettings: value);
              }),
            ),
            _buildOptionCheckbox(
              AppLocalizations.of(context)!.chatHistory,
              _options.includeChatHistory,
              (value) => setState(() {
                _options = _options.copyWith(includeChatHistory: value);
              }),
            ),
            _buildOptionCheckbox(
              AppLocalizations.of(context)!.suggestions,
              _options.includeSuggestions,
              (value) => setState(() {
                _options = _options.copyWith(includeSuggestions: value);
              }),
            ),
            if (!_options.includeSettings) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.settingsWillNotBeIncluded,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_sync,
                    size: 16,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.snapshotCreatedSuccessfully,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createBackup,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.create),
        ),
      ],
    );
  }

  Widget _buildCircularCheckbox(BuildContext context, bool value) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        color: value
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
      ),
      child: value
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }

  Widget _buildOptionCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(width: 16),
            _buildCircularCheckbox(context, value),
          ],
        ),
      ),
    );
  }

  void _createBackup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final backupService = AutoBackupService();
      // Ensure shopping lists are always included
      final backupOptions = _options.copyWith(includeShopLists: true);
      await backupService.createManualBackup(options: backupOptions);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onBackupCreated?.call();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(AppLocalizations.of(context)!.snapshotCreated),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.snapshotFailed(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
