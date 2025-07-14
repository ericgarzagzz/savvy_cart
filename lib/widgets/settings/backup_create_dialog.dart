import 'package:flutter/material.dart';

import 'package:savvy_cart/models/export/export_options.dart';
import 'package:savvy_cart/services/autobackup_service.dart';

class BackupCreateDialog extends StatefulWidget {
  final VoidCallback? onBackupCreated;

  const BackupCreateDialog({
    super.key,
    this.onBackupCreated,
  });

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
      title: const Text('Create Manual Backup'),
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
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Shopping Lists (always included)',
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
            const Text('Choose additional data to include:'),
            const SizedBox(height: 12),
            _buildOptionCheckbox(
              'Settings',
              _options.includeSettings,
              (value) => setState(() {
                _options = _options.copyWith(includeSettings: value);
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
                    Icon(Icons.info_outline, 
                         size: 16, 
                         color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your settings will not be included in this backup.',
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
                  Icon(Icons.cloud_sync, 
                       size: 16, 
                       color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This backup will be automatically synced to Google Drive.',
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createBackup,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Widget _buildOptionCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
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
                  child: Text('Backup created successfully'),
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
            content: Text('Failed to create backup: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}