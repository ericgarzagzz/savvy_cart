import 'package:savvy_cart/models/models.dart';

class ImportPreview {
  final ExportData exportData;
  final bool requiresMigration;
  final List<String> migrationSteps;
  final List<String> warnings;
  final ImportStatistics statistics;

  const ImportPreview({
    required this.exportData,
    required this.requiresMigration,
    required this.migrationSteps,
    required this.warnings,
    required this.statistics,
  });
}

class ImportStatistics {
  final int shopListCount;
  final int shopListItemCount;
  final int chatMessageCount;
  final int suggestionCount;
  final bool hasSettings;
  final String sourceVersion;
  final DateTime exportDate;

  const ImportStatistics({
    required this.shopListCount,
    required this.shopListItemCount,
    required this.chatMessageCount,
    required this.suggestionCount,
    required this.hasSettings,
    required this.sourceVersion,
    required this.exportDate,
  });

  factory ImportStatistics.fromExportData(ExportData data) {
    return ImportStatistics(
      shopListCount: data.shopLists.length,
      shopListItemCount: data.shopListItems.length,
      chatMessageCount: data.chatMessages.length,
      suggestionCount: data.suggestions.length,
      hasSettings: data.settings != null,
      sourceVersion: data.appVersion,
      exportDate: data.exportDate,
    );
  }
}