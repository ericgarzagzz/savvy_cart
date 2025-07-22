import 'package:flutter/material.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ManualBackupSection extends StatelessWidget {
  final List<BackupFileInfo> manualBackups;
  final VoidCallback onCreateBackup;
  final Function(BackupFileInfo) onRestoreBackup;
  final Function(BackupFileInfo) onDeleteBackup;

  const ManualBackupSection({
    super.key,
    required this.manualBackups,
    required this.onCreateBackup,
    required this.onRestoreBackup,
    required this.onDeleteBackup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manual Snapshots',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: onCreateBackup,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Create and manage additional snapshot files',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        if (manualBackups.isEmpty)
          const EmptyManualBackupsState()
        else
          ...manualBackups.map(
            (backup) => BackupTile(
              backup: backup,
              onRestore: () => onRestoreBackup(backup),
              onDelete: () => onDeleteBackup(backup),
            ),
          ),
      ],
    );
  }
}
