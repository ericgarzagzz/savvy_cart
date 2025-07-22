import 'package:flutter/material.dart';

import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/services/services.dart';

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
      title: const Text('Create Manual Snapshot'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose what to include in your snapshot:'),
            const SizedBox(height: 16),
            _buildOptionCheckbox(
              'Settings',
              _options.includeSettings,
              (value) => setState(() {
                _options = _options.copyWith(includeSettings: value);
              }),
            ),
            _buildOptionCheckbox(
              'Shopping Lists',
              _options.includeShopLists,
              (value) => setState(() {
                _options = _options.copyWith(includeShopLists: value);
              }),
            ),
            _buildOptionCheckbox(
              'Chat History',
              _options.includeChatHistory,
              (value) => setState(() {
                _options = _options.copyWith(includeChatHistory: value);
              }),
            ),
            _buildOptionCheckbox(
              'Suggestions',
              _options.includeSuggestions,
              (value) => setState(() {
                _options = _options.copyWith(includeSuggestions: value);
              }),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Quick Options:',
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
                    child: const Text('Full Export'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _options = ExportOptions.databaseOnly;
                    }),
                    child: const Text('Database Only'),
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
                        'Your settings will not be included in this snapshot.',
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _performExport,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create Snapshot'),
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
            title: const Text('Snapshot Created'),
            content: const Text(
              'Your snapshot has been created successfully and will be automatically synced to Google Drive.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
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
            content: Text('Snapshot failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
