import 'package:flutter/material.dart';

import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ExportDialog extends StatefulWidget {
  final ExportOptions? defaultOptions;

  const ExportDialog({super.key, this.defaultOptions});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  late ExportOptions _options;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _options = widget.defaultOptions ?? ExportOptions.fullExport;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).createManualSnapshot),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).chooseWhatToInclude),
            const SizedBox(height: 16),
            _buildOptionCheckbox(
              AppLocalizations.of(context).settings,
              _options.includeSettings,
              (value) => setState(() {
                _options = _options.copyWith(includeSettings: value);
              }),
            ),
            _buildOptionCheckbox(
              AppLocalizations.of(context).shoppingLists,
              _options.includeShopLists,
              (value) => setState(() {
                _options = _options.copyWith(includeShopLists: value);
              }),
            ),
            _buildOptionCheckbox(
              AppLocalizations.of(context).chatHistory,
              _options.includeChatHistory,
              (value) => setState(() {
                _options = _options.copyWith(includeChatHistory: value);
              }),
            ),
            _buildOptionCheckbox(
              AppLocalizations.of(context).suggestions,
              _options.includeSuggestions,
              (value) => setState(() {
                _options = _options.copyWith(includeSuggestions: value);
              }),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context).quickOptions}:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _options = ExportOptions.fullExport;
                    }),
                    child: Text(AppLocalizations.of(context).fullExport),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _options = ExportOptions.databaseOnly;
                    }),
                    child: Text(AppLocalizations.of(context).databaseOnly),
                  ),
                ),
              ],
            ),
            if (!_options.includeSettings) ...[
              const SizedBox(height: 8),
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
                        AppLocalizations.of(context).settingsWillNotBeIncluded,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _performExport,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context).createSnapshot),
        ),
      ],
    );
  }

  Widget _buildOptionCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _performExport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final backupService = AutoBackupService();
      await backupService.createManualBackup(options: _options);

      if (mounted) {
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            title: Text(AppLocalizations.of(context).snapshotCreated),
            content: Text(
              AppLocalizations.of(context).snapshotCreatedSuccessfully,
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).done),
              ),
            ],
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
              AppLocalizations.of(context).snapshotFailed(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
