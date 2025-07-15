import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class BackupRestoreDialog extends ConsumerStatefulWidget {
  final BackupFileInfo backup;
  final VoidCallback? onRestoreCompleted;

  const BackupRestoreDialog({
    super.key,
    required this.backup,
    this.onRestoreCompleted,
  });

  @override
  ConsumerState<BackupRestoreDialog> createState() => _BackupRestoreDialogState();
}

class _BackupRestoreDialogState extends ConsumerState<BackupRestoreDialog> {
  bool _isLoading = false;
  bool _replaceExisting = true;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy \'at\' HH:mm');
    
    return AlertDialog(
      title: const Text('Restore Backup'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder_zip,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.backup.fileName
                              .replaceAll('manual_backup_', '')
                              .replaceAll('.json', ''),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created: ${dateFormat.format(widget.backup.createdDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Size: ${widget.backup.formattedSize}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (widget.backup.includesSettings) ...[ 
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Replace existing data'),
              subtitle: const Text('Clear current data before restoring'),
              value: _replaceExisting,
              onChanged: (value) => setState(() {
                _replaceExisting = value ?? true;
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
                          'Important',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _replaceExisting
                              ? 'This will permanently delete all current data and replace it with the backup data.'
                              : 'This will merge the backup data with your current data. Duplicates may occur.',
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
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _restoreBackup,
          style: ElevatedButton.styleFrom(
            backgroundColor: _replaceExisting 
                ? Theme.of(context).colorScheme.error
                : null,
            foregroundColor: _replaceExisting 
                ? Theme.of(context).colorScheme.onError
                : null,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Restore'),
        ),
      ],
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

  void _restoreBackup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final backupService = AutoBackupService();
      await backupService.restoreFromBackup(
        widget.backup.filePath,
        replaceExisting: _replaceExisting,
      );
      
      if (mounted) {
        // Invalidate all Riverpod providers to refresh the UI with restored data
        _invalidateAllProviders();
        
        Navigator.of(context).pop();
        widget.onRestoreCompleted?.call();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _replaceExisting 
                        ? 'Data restored successfully'
                        : 'Backup data merged successfully'
                  ),
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
            content: Text('Failed to restore backup: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}