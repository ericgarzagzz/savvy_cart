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
}
