import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class BackupTile extends StatelessWidget {
  final BackupFileInfo backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const BackupTile({
    super.key,
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy \'at\' HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.folder_zip,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          backup.fileName
              .replaceAll('manual_backup_', '')
              .replaceAll('.json', ''),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(backup.createdDate)),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  backup.formattedSize,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (backup.includesSettings) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.settings,
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
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'restore',
              child: Row(
                children: [
                  Icon(Icons.restore, size: 18),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.restore),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'restore') {
              onRestore();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
      ),
    );
  }
}
