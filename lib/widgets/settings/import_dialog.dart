import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class ImportDialog extends ConsumerStatefulWidget {
  final BackupFileInfo backup;

  const ImportDialog({
    super.key,
    required this.backup,
  });

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
      title: const Text('Restore Backup'),
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
                        'Backup Information',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('File:', widget.backup.fileName
                          .replaceAll('manual_backup_', '')
                          .replaceAll('.json', '')),
                      _buildInfoRow('Created:', dateFormat.format(widget.backup.createdDate)),
                      _buildInfoRow('Size:', widget.backup.formattedSize),
                      _buildInfoRow('Includes Settings:', widget.backup.includesSettings ? 'Yes' : 'No'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Import Options',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              CheckboxListTile(
                title: const Text('Replace existing data'),
                subtitle: const Text('Clear all current data before importing'),
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
                            'Important',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _options.replaceExisting
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
      ),
      actions: [
        TextButton(
          onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
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
              : const Text('Restore'),
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
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
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
            title: const Text('Restore Successful'),
            content: Text(
              _options.replaceExisting 
                  ? 'Your data has been restored successfully.'
                  : 'The backup data has been merged with your current data successfully.'
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
          _isImporting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}