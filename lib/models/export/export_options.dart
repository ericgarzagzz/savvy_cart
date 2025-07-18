class ExportOptions {
  final bool includeSettings;
  final bool includeShopLists;
  final bool includeChatHistory;
  final bool includeSuggestions;

  const ExportOptions({
    this.includeSettings = true,
    this.includeShopLists = true,
    this.includeChatHistory = true,
    this.includeSuggestions = true,
  });

  ExportOptions copyWith({
    bool? includeSettings,
    bool? includeShopLists,
    bool? includeChatHistory,
    bool? includeSuggestions,
  }) {
    return ExportOptions(
      includeSettings: includeSettings ?? this.includeSettings,
      includeShopLists: includeShopLists ?? this.includeShopLists,
      includeChatHistory: includeChatHistory ?? this.includeChatHistory,
      includeSuggestions: includeSuggestions ?? this.includeSuggestions,
    );
  }

  // Predefined options for quick access
  static const ExportOptions fullExport = ExportOptions();

  static const ExportOptions databaseOnly = ExportOptions(
    includeSettings: false,
  );

  static const ExportOptions shopListsOnly = ExportOptions(
    includeSettings: false,
    includeChatHistory: false,
    includeSuggestions: false,
  );
}

class ImportOptions {
  final bool replaceExisting;
  final bool skipDuplicates;
  final bool preserveIds;

  const ImportOptions({
    this.replaceExisting = false,
    this.skipDuplicates = true,
    this.preserveIds = false,
  });

  ImportOptions copyWith({
    bool? replaceExisting,
    bool? skipDuplicates,
    bool? preserveIds,
  }) {
    return ImportOptions(
      replaceExisting: replaceExisting ?? this.replaceExisting,
      skipDuplicates: skipDuplicates ?? this.skipDuplicates,
      preserveIds: preserveIds ?? this.preserveIds,
    );
  }
}
