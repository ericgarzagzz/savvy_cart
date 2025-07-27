// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SavvyCart';

  @override
  String get appSubtitle => 'Smart Shopping Lists';

  @override
  String get settingsTitle => 'SavvyCart settings';

  @override
  String chatWithList(String listName) {
    return 'Chat with $listName';
  }

  @override
  String get searchItemPrice => 'Search Item Price';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get shoppingInsights => 'Shopping Insights';

  @override
  String get searchLists => 'Search Lists';

  @override
  String get selectGeminiModel => 'Select Gemini™ Model';

  @override
  String get aiSettings => 'AI Settings';

  @override
  String get addItem => 'Add Item';

  @override
  String get createShoppingList => 'Create Shopping List';

  @override
  String get createNewList => 'Create New List';

  @override
  String get loadMore => 'Load More';

  @override
  String get executeSelectedActions => 'Execute Selected Actions';

  @override
  String get clearAll => 'Clear All';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get goHome => 'Go Home';

  @override
  String get goToHomePage => 'Go to Home Page';

  @override
  String get enterListName => 'Enter list name';

  @override
  String get listName => 'List Name';

  @override
  String get itemName => 'Item Name';

  @override
  String get enterItemName => 'Enter item name...';

  @override
  String get searchByListName => 'Search by list name...';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get geminiApiKey => 'Google™ Gemini™ API Key';

  @override
  String get geminiModel => 'Gemini™ Model';

  @override
  String get listNameCannotBeEmpty => 'The list\'s name cannot be empty';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get data => 'Data';

  @override
  String get localization => 'Localization';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get systemLanguage => 'System Language';

  @override
  String get autoDetectFromDeviceSettings => 'Auto-detect from device settings';

  @override
  String get developer => 'Developer';

  @override
  String get generateMockData => 'Generate Mock Data';

  @override
  String get deleteDatabase => 'Delete Database';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get ready => 'Ready';

  @override
  String get notVerified => 'Not verified';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get manageBackups => 'Manage backups';

  @override
  String get addSampleShoppingLists => 'Add sample shopping lists';

  @override
  String get clearAllData => 'Clear all data';

  @override
  String get loading => 'Loading...';

  @override
  String get recommended => 'Recommended';

  @override
  String get deleteShopList => 'Delete shop list';

  @override
  String get editItemName => 'Edit Item Name';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get deleteBackup => 'Delete Backup';

  @override
  String get createManualSnapshot => 'Create Manual Snapshot';

  @override
  String get error => 'Error';

  @override
  String get toBuy => 'To Buy';

  @override
  String get inCart => 'In Cart';

  @override
  String get listsCreated => 'Lists Created';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get filterByDateRange => 'Filter by Date Range';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get tokenLimits => 'Token Limits';

  @override
  String get all => 'All';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String searchResultsCount(int count) {
    return 'Search Results ($count)';
  }

  @override
  String get noShoppingDataYet => 'No Shopping Data Yet';

  @override
  String get createFirstListDescription =>
      'Create your first shopping list to start tracking insights about your shopping patterns and spending habits.';

  @override
  String get noItemsFound => 'No items found';

  @override
  String tryDifferentSearchTerm(String searchQuery) {
    return 'Try a different search term or add \"$searchQuery\" as a new item';
  }

  @override
  String get noPriceHistoryAvailable => 'No price history available';

  @override
  String get purchaseItemToTrackPrice =>
      'Purchase this item to start tracking its price trends';

  @override
  String get noListsFound => 'No lists found';

  @override
  String get tryAdjustingFilters =>
      'Try adjusting your search terms or date filters';

  @override
  String get loadingAvailableModels => 'Loading available models...';

  @override
  String failedToRemoveItem(String error) {
    return 'Failed to remove item: $error';
  }

  @override
  String get couldNotLoadShopListItems =>
      'Could not load shop list\'s items due to an error.';

  @override
  String get errorLoadingSearchResults => 'Error loading search results';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get errorLoadingSuggestions => 'Error loading suggestions';

  @override
  String failedToLoadBackupInfo(String error) {
    return 'Failed to load backup information: $error';
  }

  @override
  String pageNotFound(String uri) {
    return 'Page not found: $uri';
  }

  @override
  String get invalidShopListId => 'Invalid shop list ID';

  @override
  String get invalidItemName => 'Invalid item name';

  @override
  String badRequest(String responseBody) {
    return 'Bad request: $responseBody';
  }

  @override
  String get invalidApiKeyOrAuth => 'Invalid API key or authentication failed';

  @override
  String get accessForbidden => 'Access forbidden - check API permissions';

  @override
  String get apiRateLimitExceeded =>
      'API rate limit exceeded. Please try again later.';

  @override
  String get internalServerError => 'Internal server error';

  @override
  String get badGateway => 'Bad gateway - service temporarily unavailable';

  @override
  String get serviceUnavailable => 'Service unavailable';

  @override
  String get gatewayTimeout => 'Gateway timeout';

  @override
  String get noInternetConnection => 'No internet connection available';

  @override
  String get requestTimedOut => 'Request timed out';

  @override
  String get invalidResponseFormat => 'Invalid response format from API';

  @override
  String get generatingMockData => 'Generating mock data...';

  @override
  String get mockDataGeneratedSuccessfully =>
      'Mock data generated successfully!';

  @override
  String errorGeneratingMockData(String error) {
    return 'Error generating mock data: $error';
  }

  @override
  String get databaseDeletedSuccessfully => 'Database deleted successfully';

  @override
  String errorDeletingDatabase(String error) {
    return 'Error deleting database: $error';
  }

  @override
  String get backupDeletedSuccessfully => 'Backup deleted successfully';

  @override
  String failedToDeleteBackup(String error) {
    return 'Failed to delete backup: $error';
  }

  @override
  String get pleaseEnterValidApiKey => 'Please enter a valid API key first';

  @override
  String get processing => 'Processing...';

  @override
  String get startYourShoppingJourney => 'Start your shopping journey';

  @override
  String get searchForItemViewHistory =>
      'Search for an item to view its price history';

  @override
  String get orChooseFromPreviousItems => 'Or choose from your previous items:';

  @override
  String get searchResults => 'Search Results:';

  @override
  String get addItemsToSeeHere =>
      'Add items to your shopping lists to see them here';

  @override
  String tryDifferentSearchOrCreate(String searchQuery) {
    return 'Try a different search term or create a chart for \"$searchQuery\"';
  }

  @override
  String get areYouSureDeleteBackup =>
      'Are you sure you want to delete this backup?';

  @override
  String get mockDataGenerationDescription =>
      'This will create sample shopping lists with items across the year for analytics testing. This may take a few moments.';

  @override
  String get databaseDeletionWarning =>
      'This will permanently delete all your data including shopping lists, items, and settings. This action cannot be undone.';

  @override
  String get shoppingListsAlwaysIncluded => 'Shopping Lists (always included)';

  @override
  String get chooseAdditionalData => 'Choose additional data to include:';

  @override
  String get settings => 'Settings';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get suggestions => 'Suggestions';

  @override
  String addSearchQuery(String searchQuery) {
    return 'Add \"$searchQuery\"';
  }

  @override
  String viewChartFor(String searchQuery) {
    return 'View chart for \"$searchQuery\"';
  }

  @override
  String get gemini2Flash => 'Gemini™ 2.0 Flash';

  @override
  String get gemini15Flash => 'Gemini™ 1.5 Flash';

  @override
  String get gemini15Pro => 'Gemini™ 1.5 Pro';

  @override
  String get geminiPro => 'Gemini™ Pro';

  @override
  String get chooseAiModelDescription =>
      'Choose the AI model to use for processing';

  @override
  String get actionsDiscarded => 'Actions Discarded';

  @override
  String get weeklyOverview => 'Weekly Overview';

  @override
  String get errorLoadingInsights => 'Error loading insights';

  @override
  String get noMatchingItemsFound => 'No matching items found';

  @override
  String get removeItemAndSuggestion => 'Remove Item and Suggestion?';

  @override
  String get removeSuggestion => 'Remove Suggestion?';

  @override
  String removeItemAndSuggestionDesc(String itemName) {
    return 'This will remove \"$itemName\" from your current shopping list and also from your suggestions.';
  }

  @override
  String removeSuggestionDesc(String itemName) {
    return 'This will remove \"$itemName\" from your suggestions. It will not affect your current shopping list.';
  }

  @override
  String get remove => 'Remove';

  @override
  String itemsSelected(int count) {
    return '$count selected';
  }

  @override
  String chatWith(String listName) {
    return 'Chat with $listName';
  }

  @override
  String get reviewAiSuggestions => 'Review AI Suggestions';

  @override
  String get pleaseSelectAtLeastOneAction =>
      'Please select at least one action to execute';

  @override
  String get appliedActions => 'Applied Actions';

  @override
  String get noActionsWereApplied => 'No actions were applied';

  @override
  String get frequentlyBoughtItems => 'Frequently Bought Items';

  @override
  String get searchItem => 'Search item';

  @override
  String get noFrequentlyBoughtItems => 'No frequently bought items';

  @override
  String get completeListsToSeeMostBought =>
      'Complete shopping lists to see your most bought items';

  @override
  String timesPurchased(int count) {
    return 'Purchased $count times';
  }

  @override
  String get errorLoadingFrequentlyBought =>
      'Error loading frequently bought items';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get discoverShoppingPatterns => 'Discover your shopping patterns';

  @override
  String get errorLoadingPriceHistory => 'Error loading price history';

  @override
  String get onlyOnePurchaseFound => 'Only one purchase found';

  @override
  String lastPurchasedFor(String price) {
    return 'Last purchased for $price';
  }

  @override
  String purchasedOn(String date) {
    return 'Purchased on $date';
  }

  @override
  String get purchaseMoreTimesToSeeTrends =>
      'Purchase this item more times to see price trends';

  @override
  String get average => 'Average';

  @override
  String get lowest => 'Lowest';

  @override
  String get highest => 'Highest';

  @override
  String get searchOrAddNewItem => 'Search or add new item...';

  @override
  String get frequentlyBought => 'Frequently Bought';

  @override
  String errorLoadingResults(String error) {
    return 'Error loading results: $error';
  }

  @override
  String get searchResultsZero => 'Search Results (0)';

  @override
  String tryDifferentSearchOrAdd(String searchQuery) {
    return 'Try a different search term or add \"$searchQuery\" as a new item';
  }

  @override
  String get errorLoadingItem => 'Error loading item';

  @override
  String get itemNotFound => 'Item not found';

  @override
  String confirmDeleteItem(String itemName) {
    return 'Are you sure you want to delete \"$itemName\"?';
  }

  @override
  String get quantity => 'Quantity';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String get errorLoadingShopListItems =>
      'Could not load shop list\'s items due to an error.';

  @override
  String get noItemsInCartYet => 'No items in cart yet';

  @override
  String get readyToStartShopping => 'Ready to start shopping?';

  @override
  String get itemsYouCheckOffWillAppearHere =>
      'Items you check off will appear here';

  @override
  String get tapPlusButtonToAddFirstItem =>
      'Tap the + button below to add your first item';

  @override
  String get needMoreItems => 'Need more items?';

  @override
  String get tapButtonBelowToAddMoreItems =>
      'Tap the button below to add more items';

  @override
  String get addItemsYouStillNeedToBuy => 'Add items you still need to buy';

  @override
  String get tapButtonBelowToAddFirstItem =>
      'Tap the button below to add your first item';

  @override
  String get addFirstItemToGetStarted => 'Add your first item to get started';

  @override
  String get generate => 'Generate';

  @override
  String get ai => 'AI';

  @override
  String get filterModels => 'Filter Models';

  @override
  String get thinkingCapabilities => 'Thinking Capabilities';

  @override
  String get inputTokensInMillions => 'Input Tokens (in millions)';

  @override
  String get minValue => 'Min Value';

  @override
  String get maxValue => 'Max Value';

  @override
  String get outputTokensInMillions => 'Output Tokens (in millions)';

  @override
  String get temperatureRange => 'Temperature Range';

  @override
  String get retry => 'Retry';

  @override
  String get actionsApplied => 'Actions Applied';

  @override
  String get applyActions => 'Apply Actions';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get pleaseGoBackToHomeScreen => 'Please go back to the home screen';

  @override
  String get priceTrendForLastPurchases => 'Price trend for last purchases';

  @override
  String get settingsWillNotBeIncluded => 'Settings will not be included';

  @override
  String get snapshotCreatedSuccessfully => 'Snapshot created successfully';

  @override
  String get create => 'Create';

  @override
  String get snapshotCreated => 'Snapshot Created';

  @override
  String snapshotFailed(String error) {
    return 'Snapshot failed: $error';
  }

  @override
  String get restore => 'Restore';

  @override
  String get manualSnapshots => 'Manual Snapshots';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get replaceExistingData => 'Replace existing data';

  @override
  String get clearCurrentDataBeforeRestoring =>
      'Clear all current data before restoring';

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get chooseWhatToInclude => 'Choose what to include';

  @override
  String get fullExport => 'Full Export';

  @override
  String get databaseOnly => 'Database Only';

  @override
  String get createSnapshot => 'Create Snapshot';

  @override
  String get done => 'Done';

  @override
  String get clearAllCurrentDataBeforeImporting =>
      'Clear all current data before importing';

  @override
  String get restoreSuccessful => 'Restore Successful';

  @override
  String filtersWithCount(int count) {
    return 'Filters ($count)';
  }

  @override
  String get filter => 'Filter';

  @override
  String get clearAllFilters => 'Clear All Filters';

  @override
  String errorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get created => 'Created';

  @override
  String get size => 'Size';

  @override
  String get important => 'Important';

  @override
  String get dataReplacementWarning =>
      'This will permanently delete all current data and replace it with the backup data.';

  @override
  String get dataMergeWarning =>
      'This will merge the backup data with your current data. Duplicates may occur.';

  @override
  String get dataRestoredSuccessfully => 'Data restored successfully';

  @override
  String get backupDataMergedSuccessfully => 'Backup data merged successfully';

  @override
  String get quickOptions => 'Quick Options';

  @override
  String get shoppingLists => 'Shopping Lists';

  @override
  String get backupInformation => 'Backup Information';

  @override
  String get file => 'File';

  @override
  String get includesSettings => 'Includes Settings';

  @override
  String get importOptions => 'Import Options';

  @override
  String get dataRestoredSuccessfullyMessage =>
      'Your data has been restored successfully.';

  @override
  String get backupDataMergedSuccessfullyMessage =>
      'The backup data has been merged with your current data successfully.';

  @override
  String get aiAssistantConfiguration => 'AI Assistant Configuration';

  @override
  String get configureAiAssistantDescription =>
      'Configure your AI assistant to help manage shopping lists and provide suggestions.';

  @override
  String get apiConfiguration => 'API Configuration';

  @override
  String get setupGeminiApiKeyDescription =>
      'Set up your Google™ Gemini™ API key to enable AI features';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get aboutGoogleGemini => 'About Google™ Gemini™';

  @override
  String get getFreeApiKeyFromGoogleAi =>
      'Get your free API key from Google™ AI Studio';

  @override
  String get aiFeaturesIncludeChatAndSuggestions =>
      'AI features include chat assistance and smart suggestions';

  @override
  String get apiKeyStoredSecurely =>
      'Your API key is stored securely on your device';

  @override
  String get apiUsageSubjectToRateLimits =>
      'API usage may be subject to Google™\'s rate limits';

  @override
  String get googleTrademarkDisclaimer =>
      'Google™ and Gemini™ are trademarks of Google LLC. This app is not affiliated with Google.';

  @override
  String get automaticBackup => 'Automatic Backup';

  @override
  String get dataAutomaticallyBackedUpToDrive =>
      'Your data is automatically backed up to Google Drive';

  @override
  String get automaticBackupEnabledAndWorking =>
      'Automatic backup is enabled and working';

  @override
  String get automaticBackupConfigurationDetected =>
      'Automatic backup configuration detected';

  @override
  String get automaticBackupInfoMessage =>
      'Automatic backup runs periodically in the background. Manual snapshots work locally, but won\'t survive app uninstalls until automatic backup has synced them to Google Drive.';

  @override
  String get howBackupWorks => 'How Backup Works';

  @override
  String get automaticBackupSyncsToGoogleDrive =>
      'Automatic backup syncs your data to Google Drive';

  @override
  String get manualSnapshotsStoredLocallyAndSynced =>
      'Manual snapshots are stored locally and included in automatic sync';

  @override
  String get restoringWillReplaceCurrentData =>
      'Restoring will replace your current data';

  @override
  String get backupsIncludeShoppingListsChatAndSettings =>
      'Backups include shopping lists, chat history, and optionally settings';

  @override
  String get noManualSnapshotsYet => 'No manual snapshots yet';

  @override
  String get createManualSnapshotForAdditionalControl =>
      'Create a manual snapshot to have additional control over your data';

  @override
  String get createAndManageAdditionalSnapshotFiles =>
      'Create and manage additional snapshot files';

  @override
  String get thinking => 'Thinking';

  @override
  String get input => 'Input';

  @override
  String get output => 'Output';

  @override
  String get temperature => 'Temperature';

  @override
  String get tokensUnit => 'M tokens';

  @override
  String get filteredBy => 'Filtered by';

  @override
  String get clear => 'Clear';

  @override
  String confirmDeleteShopList(String listName) {
    return 'Are you sure you want to delete the shop list \"$listName\"?';
  }

  @override
  String get noShoppingListsYet => 'No Shopping Lists Yet';

  @override
  String get createFirstShoppingListDescription =>
      'Create your first shopping list above to start organizing your groceries and never forget an item again!';

  @override
  String get recentLists => 'Recent Lists';

  @override
  String itemsShown(int count) {
    return '$count shown';
  }

  @override
  String itemsCompleted(int completed, int total) {
    return '$completed of $total items completed';
  }

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get viewList => 'View List';

  @override
  String itemsProgress(int completed, int total) {
    return '$completed of $total items';
  }

  @override
  String get remaining => 'Remaining';

  @override
  String get allItems => 'All Items';

  @override
  String allItemsWithCount(int count) {
    return 'All Items ($count)';
  }

  @override
  String get apiConnected => 'API Connected';

  @override
  String get connected => 'Connected';

  @override
  String connectedWithModels(int count) {
    return 'Connected ($count models available)';
  }

  @override
  String get verifyingApiKey => 'Verifying API Key...';

  @override
  String get checkingConnectionGemini => 'Checking connection to Gemini API...';

  @override
  String get manageList => 'Manage';

  @override
  String get licenses => 'Licenses';

  @override
  String get aiSetupRequired => 'AI Setup Required';

  @override
  String get aiSetupRequiredMessage =>
      'To use AI features, please configure your API key in Settings.';

  @override
  String get goToSettings => 'Go to Settings';
}
