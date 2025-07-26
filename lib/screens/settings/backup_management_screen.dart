import 'package:flutter/material.dart';

import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class BackupManagementScreen extends StatefulWidget {
  const BackupManagementScreen({super.key});

  @override
  State<BackupManagementScreen> createState() => _BackupManagementScreenState();
}

class _BackupManagementScreenState extends State<BackupManagementScreen> {
  final AutoBackupService _backupService = AutoBackupService();
  AutoBackupInfo? _autoBackupInfo;
  List<BackupFileInfo> _manualBackups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBackupInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.backupAndRestore),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBackupInfo,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoBackupSection(autoBackupInfo: _autoBackupInfo),
                    const SizedBox(height: 24),
                    ManualBackupSection(
                      manualBackups: _manualBackups,
                      onCreateBackup: _createManualBackup,
                      onRestoreBackup: _restoreBackup,
                      onDeleteBackup: _deleteBackup,
                    ),
                    const SizedBox(height: 24),
                    const BackupInfoSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _loadBackupInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final autoBackupInfo = await _backupService.getAutoBackupInfo();
      final manualBackups = await _backupService.getAvailableBackups();

      setState(() {
        _autoBackupInfo = autoBackupInfo;
        _manualBackups = manualBackups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.failedToLoadBackupInfo(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _createManualBackup() {
    showDialog(
      context: context,
      builder: (context) => BackupCreateDialog(
        onBackupCreated: () {
          _loadBackupInfo(); // Refresh the list
        },
      ),
    );
  }

  void _restoreBackup(BackupFileInfo backup) {
    showDialog(
      context: context,
      builder: (context) => BackupRestoreDialog(
        backup: backup,
        onRestoreCompleted: () {
          // Optionally refresh or show success message
        },
      ),
    );
  }

  void _deleteBackup(BackupFileInfo backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteBackup),
        content: Text(
          '${AppLocalizations.of(context)!.areYouSureDeleteBackup}\n\n"${backup.fileName}"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await _backupService.deleteBackup(backup.filePath);
                _loadBackupInfo(); // Refresh the list

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.backupDeletedSuccessfully,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.failedToDeleteBackup(e.toString()),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
