import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class AutoBackupService {
  static const String currentFormatVersion = '1.0';
  static const String currentAppVersion = '1.0.0';
  static const int currentDatabaseVersion = 7;
  static const String backupDirectoryName = 'backups';

  /// Create a manual backup file in the app's data directory
  /// This will be automatically included in Android's AutoBackup
  Future<String> createManualBackup({
    ExportOptions options = ExportOptions.fullExport,
  }) async {
    try {
      if (kDebugMode) {
        print('Creating manual backup...');
      }

      // Collect data based on options
      final exportData = await _collectExportData(options);

      // Generate filename with timestamp
      final timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());
      final filename = 'manual_backup_$timestamp.json';

      // Get app's backup directory
      final backupDir = await _getBackupDirectory();
      final file = File('${backupDir.path}/$filename');

      // Write data to file
      await file.writeAsString(jsonEncode(exportData.toJson()));

      if (kDebugMode) {
        print('Manual backup created: ${file.path}');
      }

      return file.path;
    } on FileSystemException catch (e) {
      FileIOErrorHandler.handleFileSystemException(e);
      rethrow; // This line should never be reached due to the throw above
    } on FormatException catch (e) {
      FileIOErrorHandler.handleFormatException(e, 'backup');
      rethrow; // This line should never be reached due to the throw above
    } on DatabaseOperationException catch (e) {
      throw BackupCreationException(
        'Database error during backup: ${e.message}',
        e,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Manual backup failed: $e');
      }
      throw BackupCreationException('Failed to create backup: $e', e);
    }
  }

  /// Get list of available manual backup files
  Future<List<BackupFileInfo>> getAvailableBackups() async {
    try {
      final backupDir = await _getBackupDirectory();

      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.json'))
          .cast<File>()
          .toList();

      final backupInfos = <BackupFileInfo>[];

      for (final file in files) {
        try {
          final stat = await file.stat();
          final content = await file.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;

          backupInfos.add(
            BackupFileInfo(
              filePath: file.path,
              fileName: file.uri.pathSegments.last,
              fileSize: stat.size,
              createdDate: DateTime.parse(json['exportDate'] as String),
              includesSettings: json['includeSettings'] as bool? ?? false,
              databaseVersion: json['databaseVersion'] as int? ?? 0,
            ),
          );
        } on FileSystemException catch (e) {
          if (kDebugMode) {
            print('Error reading backup file ${file.path}: $e');
          }
          // Skip files with access issues
        } on FormatException catch (e) {
          if (kDebugMode) {
            print('Corrupted backup file ${file.path}: $e');
          }
          // Skip corrupted files
        } catch (e) {
          if (kDebugMode) {
            print('Unexpected error reading backup file ${file.path}: $e');
          }
          // Skip any other problematic files
        }
      }

      // Sort by creation date (newest first)
      backupInfos.sort((a, b) => b.createdDate.compareTo(a.createdDate));

      return backupInfos;
    } on FileSystemException catch (e) {
      if (kDebugMode) {
        print('Error accessing backup directory: $e');
      }
      throw FilePermissionException('Cannot access backup directory', e);
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error getting available backups: $e');
      }
      throw BackupCreationException('Failed to retrieve backup list: $e', e);
    }
  }

  /// Restore from a backup file
  Future<void> restoreFromBackup(
    String filePath, {
    bool replaceExisting = false,
  }) async {
    try {
      if (kDebugMode) {
        print('Restoring from backup: $filePath');
      }

      final file = File(filePath);
      FileIOErrorHandler.validateBackupFile(file);

      if (!await file.exists()) {
        throw FileNotFoundIOException('Backup file not found: $filePath');
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final exportData = ExportData.fromJson(json);

      // Apply migrations if needed
      Map<String, List<Map<String, dynamic>>> migratedData =
          exportData.rawTables;
      if (exportData.databaseVersion < currentDatabaseVersion) {
        migratedData = await _applyMigrationChain(
          exportData.rawTables,
          from: exportData.databaseVersion,
          to: currentDatabaseVersion,
        );
      }

      // Clear existing data if replace option is enabled
      if (replaceExisting) {
        await _clearExistingData();
      }

      // Import database data
      await _importDatabaseData(migratedData);

      // Import settings if included
      if (exportData.includeSettings && exportData.settings != null) {
        await _importSettings(exportData.settings!);
      }

      if (kDebugMode) {
        print('Restore completed successfully');
      }
    } on FileSystemException catch (e) {
      FileIOErrorHandler.handleFileSystemException(e);
    } on FormatException catch (e) {
      FileIOErrorHandler.handleFormatException(e, 'backup');
    } on DatabaseOperationException catch (e) {
      throw BackupRestoreException(
        'Database error during restore: ${e.message}',
        e,
      );
    } on FileIOException {
      // Re-throw file I/O exceptions as-is
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Restore failed: $e');
      }
      throw BackupRestoreException('Failed to restore backup: $e', e);
    }
  }

  /// Delete a backup file
  Future<void> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete backup: $e');
    }
  }

  /// Get information about AutoBackup status
  Future<AutoBackupInfo> getAutoBackupInfo() async {
    try {
      final backupDir = await _getBackupDirectory();
      final backups = await getAvailableBackups();

      return AutoBackupInfo(
        isEnabled: true, // AutoBackup is always enabled if configured
        lastManualSnapshotDate: backups.isNotEmpty
            ? backups.first.createdDate
            : null,
        manualSnapshotCount: backups.length,
        totalSnapshotSize: backups.fold(
          0,
          (sum, backup) => sum + backup.fileSize,
        ),
        backupDirectory: backupDir.path,
      );
    } catch (e) {
      return AutoBackupInfo(
        isEnabled: false,
        lastManualSnapshotDate: null,
        manualSnapshotCount: 0,
        totalSnapshotSize: 0,
        backupDirectory: '',
      );
    }
  }

  // Private helper methods

  Future<Directory> _getBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/$backupDirectoryName');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    return backupDir;
  }

  Future<ExportData> _collectExportData(ExportOptions options) async {
    final db = await DatabaseHelper.instance.database;
    final dbVersion = await db.getVersion();

    // Collect raw table data
    final rawTables = <String, List<Map<String, dynamic>>>{};

    if (options.includeShopLists) {
      rawTables['shop_lists'] = await db.query('shop_lists');
      rawTables['shop_list_items'] = await db.query('shop_list_items');
    }

    if (options.includeSuggestions) {
      rawTables['suggestions'] = await db.query('suggestions');
    }

    if (options.includeChatHistory) {
      rawTables['chat_messages'] = await db.query('chat_messages');
    }

    // Parse into models
    final shopLists = options.includeShopLists
        ? (rawTables['shop_lists'] ?? [])
              .map((item) => ShopList.fromMap(item))
              .toList()
        : <ShopList>[];

    final shopListItems = options.includeShopLists
        ? (rawTables['shop_list_items'] ?? [])
              .map((item) => ShopListItem.fromMap(item))
              .toList()
        : <ShopListItem>[];

    final suggestions = options.includeSuggestions
        ? (rawTables['suggestions'] ?? [])
              .map((item) => Suggestion.fromMap(item))
              .toList()
        : <Suggestion>[];

    final chatMessages = options.includeChatHistory
        ? (rawTables['chat_messages'] ?? [])
              .map((item) => ChatMessage.fromMap(item))
              .toList()
        : <ChatMessage>[];

    // Get settings if requested
    AiSettings? settings;
    if (options.includeSettings) {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('ai_api_key') ?? '';
      final model = prefs.getString('ai_model') ?? 'gemini-2.0-flash';
      final themeMode = prefs.getString('theme_mode');
      settings = AiSettings(apiKey: apiKey, model: model, themeMode: themeMode);
    }

    return ExportData(
      formatVersion: currentFormatVersion,
      databaseVersion: dbVersion,
      appVersion: currentAppVersion,
      exportDate: DateTime.now(),
      includeSettings: options.includeSettings,
      rawTables: rawTables,
      shopLists: shopLists,
      shopListItems: shopListItems,
      suggestions: suggestions,
      chatMessages: chatMessages,
      settings: settings,
    );
  }

  Future<Map<String, List<Map<String, dynamic>>>> _applyMigrationChain(
    Map<String, List<Map<String, dynamic>>> data, {
    required int from,
    required int to,
  }) async {
    var currentData = Map<String, List<Map<String, dynamic>>>.from(data);

    for (int version = from + 1; version <= to; version++) {
      currentData = await _applyMigrationStep(currentData, version);
    }

    return currentData;
  }

  Future<Map<String, List<Map<String, dynamic>>>> _applyMigrationStep(
    Map<String, List<Map<String, dynamic>>> data,
    int targetVersion,
  ) async {
    switch (targetVersion) {
      case 6:
        return _migrateToV6(data);
      case 7:
        return _migrateToV7(data);
      default:
        return data;
    }
  }

  Map<String, List<Map<String, dynamic>>> _migrateToV6(
    Map<String, List<Map<String, dynamic>>> data,
  ) {
    final chatMessages = List<Map<String, dynamic>>.from(
      data['chat_messages'] ?? [],
    );

    for (var message in chatMessages) {
      message['actions_discarded'] = 0;
    }

    return {...data, 'chat_messages': chatMessages};
  }

  Map<String, List<Map<String, dynamic>>> _migrateToV7(
    Map<String, List<Map<String, dynamic>>> data,
  ) {
    final chatMessages = List<Map<String, dynamic>>.from(
      data['chat_messages'] ?? [],
    );

    for (var message in chatMessages) {
      message.remove('actions_discarded');
    }

    return {...data, 'chat_messages': chatMessages};
  }

  Future<void> _clearExistingData() async {
    final db = await DatabaseHelper.instance.database;

    await db.delete('chat_messages');
    await db.delete('shop_list_items');
    await db.delete('shop_lists');
    await db.delete('suggestions');
  }

  Future<void> _importDatabaseData(
    Map<String, List<Map<String, dynamic>>> data,
  ) async {
    final db = await DatabaseHelper.instance.database;

    // Import in dependency order
    if (data.containsKey('shop_lists')) {
      for (var item in data['shop_lists']!) {
        await db.insert('shop_lists', item);
      }
    }

    if (data.containsKey('shop_list_items')) {
      for (var item in data['shop_list_items']!) {
        await db.insert('shop_list_items', item);
      }
    }

    if (data.containsKey('suggestions')) {
      for (var item in data['suggestions']!) {
        await db.insert('suggestions', item);
      }
    }

    if (data.containsKey('chat_messages')) {
      for (var item in data['chat_messages']!) {
        await db.insert('chat_messages', item);
      }
    }
  }

  Future<void> _importSettings(AiSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_api_key', settings.apiKey);
    await prefs.setString('ai_model', settings.model);

    // Import theme settings if available
    if (settings.themeMode != null) {
      await prefs.setString('theme_mode', settings.themeMode!);
    }
  }
}

class BackupFileInfo {
  final String filePath;
  final String fileName;
  final int fileSize;
  final DateTime createdDate;
  final bool includesSettings;
  final int databaseVersion;

  const BackupFileInfo({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.createdDate,
    required this.includesSettings,
    required this.databaseVersion,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class AutoBackupInfo {
  final bool isEnabled;
  final DateTime? lastManualSnapshotDate;
  final int manualSnapshotCount;
  final int totalSnapshotSize;
  final String backupDirectory;

  const AutoBackupInfo({
    required this.isEnabled,
    required this.lastManualSnapshotDate,
    required this.manualSnapshotCount,
    required this.totalSnapshotSize,
    required this.backupDirectory,
  });

  String get formattedTotalSize {
    if (totalSnapshotSize < 1024) return '${totalSnapshotSize}B';
    if (totalSnapshotSize < 1024 * 1024) {
      return '${(totalSnapshotSize / 1024).toStringAsFixed(1)}KB';
    }
    return '${(totalSnapshotSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
