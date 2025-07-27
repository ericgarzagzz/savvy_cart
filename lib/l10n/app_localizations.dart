import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('ru'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SavvyCart'**
  String get appTitle;

  /// Subtitle shown under the main app title
  ///
  /// In en, this message translates to:
  /// **'Smart Shopping Lists'**
  String get appSubtitle;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'SavvyCart settings'**
  String get settingsTitle;

  /// Title for chat screen with shopping list
  ///
  /// In en, this message translates to:
  /// **'Chat with {listName}'**
  String chatWithList(String listName);

  /// Title for price search screen
  ///
  /// In en, this message translates to:
  /// **'Search Item Price'**
  String get searchItemPrice;

  /// Title for backup management screen
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// Title for insights screen
  ///
  /// In en, this message translates to:
  /// **'Shopping Insights'**
  String get shoppingInsights;

  /// Title for list search screen
  ///
  /// In en, this message translates to:
  /// **'Search Lists'**
  String get searchLists;

  /// Title for model selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Gemini™ Model'**
  String get selectGeminiModel;

  /// Title for AI settings screen
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// Button to add new item to shopping list
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// Button to create new shopping list
  ///
  /// In en, this message translates to:
  /// **'Create Shopping List'**
  String get createShoppingList;

  /// Button text for creating new list
  ///
  /// In en, this message translates to:
  /// **'Create New List'**
  String get createNewList;

  /// Button to load more items
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// Button to execute AI actions
  ///
  /// In en, this message translates to:
  /// **'Execute Selected Actions'**
  String get executeSelectedActions;

  /// Button to clear all selections
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Button to apply changes
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Button to cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button to save changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button to delete item
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button to confirm action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Button to close dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Button to navigate to home
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// Button to navigate to home page
  ///
  /// In en, this message translates to:
  /// **'Go to Home Page'**
  String get goToHomePage;

  /// Hint text for list name input
  ///
  /// In en, this message translates to:
  /// **'Enter list name'**
  String get enterListName;

  /// Label for list name field
  ///
  /// In en, this message translates to:
  /// **'List Name'**
  String get listName;

  /// Label for item name field
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// Hint text for item name input
  ///
  /// In en, this message translates to:
  /// **'Enter item name...'**
  String get enterItemName;

  /// Hint text for list search
  ///
  /// In en, this message translates to:
  /// **'Search by list name...'**
  String get searchByListName;

  /// Hint text for chat input
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// Label for API key field
  ///
  /// In en, this message translates to:
  /// **'Google™ Gemini™ API Key'**
  String get geminiApiKey;

  /// Label for model selection
  ///
  /// In en, this message translates to:
  /// **'Gemini™ Model'**
  String get geminiModel;

  /// Validation message for empty list name
  ///
  /// In en, this message translates to:
  /// **'The list\'s name cannot be empty'**
  String get listNameCannotBeEmpty;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Settings section title for language settings
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// Language settings option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Option to use system language
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get systemLanguage;

  /// Description for system language option
  ///
  /// In en, this message translates to:
  /// **'Auto-detect from device settings'**
  String get autoDetectFromDeviceSettings;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Settings option to generate sample data
  ///
  /// In en, this message translates to:
  /// **'Generate Mock Data'**
  String get generateMockData;

  /// Settings option to delete all data
  ///
  /// In en, this message translates to:
  /// **'Delete Database'**
  String get deleteDatabase;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Settings item for app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Status indicating AI is ready
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// Status indicating API key not verified
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// Status indicating API not configured
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// Settings option description
  ///
  /// In en, this message translates to:
  /// **'Manage backups'**
  String get manageBackups;

  /// Settings option description
  ///
  /// In en, this message translates to:
  /// **'Add sample shopping lists'**
  String get addSampleShoppingLists;

  /// Settings option description
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Label for recommended option
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// Dialog title for deleting shopping list
  ///
  /// In en, this message translates to:
  /// **'Delete shop list'**
  String get deleteShopList;

  /// Dialog title for editing item name
  ///
  /// In en, this message translates to:
  /// **'Edit Item Name'**
  String get editItemName;

  /// Dialog title for deleting item
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// Dialog title for deleting backup
  ///
  /// In en, this message translates to:
  /// **'Delete Backup'**
  String get deleteBackup;

  /// Dialog title for creating backup
  ///
  /// In en, this message translates to:
  /// **'Create Manual Snapshot'**
  String get createManualSnapshot;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Section header for items to buy
  ///
  /// In en, this message translates to:
  /// **'To Buy'**
  String get toBuy;

  /// Section header for items in cart
  ///
  /// In en, this message translates to:
  /// **'In Cart'**
  String get inCart;

  /// Statistics label for number of lists
  ///
  /// In en, this message translates to:
  /// **'Lists Created'**
  String get listsCreated;

  /// Statistics label for total spending
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// Filter section title
  ///
  /// In en, this message translates to:
  /// **'Filter by Date Range'**
  String get filterByDateRange;

  /// Date picker label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Date picker label
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Filter section for token limits
  ///
  /// In en, this message translates to:
  /// **'Token Limits'**
  String get tokenLimits;

  /// Filter option for all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Affirmative response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Search results counter
  ///
  /// In en, this message translates to:
  /// **'Search Results ({count})'**
  String searchResultsCount(int count);

  /// Empty state title for insights
  ///
  /// In en, this message translates to:
  /// **'No Shopping Data Yet'**
  String get noShoppingDataYet;

  /// Description for insights empty state
  ///
  /// In en, this message translates to:
  /// **'Create your first shopping list to start tracking insights about your shopping patterns and spending habits.'**
  String get createFirstListDescription;

  /// Empty state for search results
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// Help text for empty search results
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or add \"{searchQuery}\" as a new item'**
  String tryDifferentSearchTerm(String searchQuery);

  /// Empty state for price chart
  ///
  /// In en, this message translates to:
  /// **'No price history available'**
  String get noPriceHistoryAvailable;

  /// Instructions for price tracking
  ///
  /// In en, this message translates to:
  /// **'Purchase this item to start tracking its price trends'**
  String get purchaseItemToTrackPrice;

  /// Empty state for list search
  ///
  /// In en, this message translates to:
  /// **'No lists found'**
  String get noListsFound;

  /// Help text for empty search results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms or date filters'**
  String get tryAdjustingFilters;

  /// Loading text for model selection
  ///
  /// In en, this message translates to:
  /// **'Loading available models...'**
  String get loadingAvailableModels;

  /// Error message for item removal failure
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item: {error}'**
  String failedToRemoveItem(String error);

  /// Error message for loading list items
  ///
  /// In en, this message translates to:
  /// **'Could not load shop list\'s items due to an error.'**
  String get couldNotLoadShopListItems;

  /// Error message for search failure
  ///
  /// In en, this message translates to:
  /// **'Error loading search results'**
  String get errorLoadingSearchResults;

  /// Generic retry message
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// Error message for suggestion loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading suggestions'**
  String get errorLoadingSuggestions;

  /// Error message for backup loading failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load backup information: {error}'**
  String failedToLoadBackupInfo(String error);

  /// Error message for invalid routes
  ///
  /// In en, this message translates to:
  /// **'Page not found: {uri}'**
  String pageNotFound(String uri);

  /// Error message for invalid list ID
  ///
  /// In en, this message translates to:
  /// **'Invalid shop list ID'**
  String get invalidShopListId;

  /// Error message for invalid item name
  ///
  /// In en, this message translates to:
  /// **'Invalid item name'**
  String get invalidItemName;

  /// API error for bad request
  ///
  /// In en, this message translates to:
  /// **'Bad request: {responseBody}'**
  String badRequest(String responseBody);

  /// API error for authentication failure
  ///
  /// In en, this message translates to:
  /// **'Invalid API key or authentication failed'**
  String get invalidApiKeyOrAuth;

  /// API error for forbidden access
  ///
  /// In en, this message translates to:
  /// **'Access forbidden - check API permissions'**
  String get accessForbidden;

  /// API error for rate limiting
  ///
  /// In en, this message translates to:
  /// **'API rate limit exceeded. Please try again later.'**
  String get apiRateLimitExceeded;

  /// API error for server issues
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get internalServerError;

  /// API error for gateway issues
  ///
  /// In en, this message translates to:
  /// **'Bad gateway - service temporarily unavailable'**
  String get badGateway;

  /// API error for service unavailability
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get serviceUnavailable;

  /// API error for timeout
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get gatewayTimeout;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection available'**
  String get noInternetConnection;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get requestTimedOut;

  /// API response format error
  ///
  /// In en, this message translates to:
  /// **'Invalid response format from API'**
  String get invalidResponseFormat;

  /// Progress message for mock data generation
  ///
  /// In en, this message translates to:
  /// **'Generating mock data...'**
  String get generatingMockData;

  /// Success message for mock data generation
  ///
  /// In en, this message translates to:
  /// **'Mock data generated successfully!'**
  String get mockDataGeneratedSuccessfully;

  /// Error message for mock data generation failure
  ///
  /// In en, this message translates to:
  /// **'Error generating mock data: {error}'**
  String errorGeneratingMockData(String error);

  /// Success message for database deletion
  ///
  /// In en, this message translates to:
  /// **'Database deleted successfully'**
  String get databaseDeletedSuccessfully;

  /// Error message for database deletion failure
  ///
  /// In en, this message translates to:
  /// **'Error deleting database: {error}'**
  String errorDeletingDatabase(String error);

  /// Success message for backup deletion
  ///
  /// In en, this message translates to:
  /// **'Backup deleted successfully'**
  String get backupDeletedSuccessfully;

  /// Error message for backup deletion failure
  ///
  /// In en, this message translates to:
  /// **'Failed to delete backup: {error}'**
  String failedToDeleteBackup(String error);

  /// Validation message for API key
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid API key first'**
  String get pleaseEnterValidApiKey;

  /// Processing indicator text
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Encouraging text for new users
  ///
  /// In en, this message translates to:
  /// **'Start your shopping journey'**
  String get startYourShoppingJourney;

  /// Instructions for price search
  ///
  /// In en, this message translates to:
  /// **'Search for an item to view its price history'**
  String get searchForItemViewHistory;

  /// Alternative option text
  ///
  /// In en, this message translates to:
  /// **'Or choose from your previous items:'**
  String get orChooseFromPreviousItems;

  /// Search results section header
  ///
  /// In en, this message translates to:
  /// **'Search Results:'**
  String get searchResults;

  /// Instructions for empty state
  ///
  /// In en, this message translates to:
  /// **'Add items to your shopping lists to see them here'**
  String get addItemsToSeeHere;

  /// Help text with create option
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or create a chart for \"{searchQuery}\"'**
  String tryDifferentSearchOrCreate(String searchQuery);

  /// Confirmation message for backup deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this backup?'**
  String get areYouSureDeleteBackup;

  /// Description for mock data generation
  ///
  /// In en, this message translates to:
  /// **'This will create sample shopping lists with items across the year for analytics testing. This may take a few moments.'**
  String get mockDataGenerationDescription;

  /// Warning message for database deletion
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your data including shopping lists, items, and settings. This action cannot be undone.'**
  String get databaseDeletionWarning;

  /// Backup option description
  ///
  /// In en, this message translates to:
  /// **'Shopping Lists (always included)'**
  String get shoppingListsAlwaysIncluded;

  /// Backup options description
  ///
  /// In en, this message translates to:
  /// **'Choose additional data to include:'**
  String get chooseAdditionalData;

  /// Settings backup option
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Chat history backup option
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// Suggestions backup option
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// Button to add search term as item
  ///
  /// In en, this message translates to:
  /// **'Add \"{searchQuery}\"'**
  String addSearchQuery(String searchQuery);

  /// Button to view price chart
  ///
  /// In en, this message translates to:
  /// **'View chart for \"{searchQuery}\"'**
  String viewChartFor(String searchQuery);

  /// AI model name
  ///
  /// In en, this message translates to:
  /// **'Gemini™ 2.0 Flash'**
  String get gemini2Flash;

  /// AI model name
  ///
  /// In en, this message translates to:
  /// **'Gemini™ 1.5 Flash'**
  String get gemini15Flash;

  /// AI model name
  ///
  /// In en, this message translates to:
  /// **'Gemini™ 1.5 Pro'**
  String get gemini15Pro;

  /// AI model name
  ///
  /// In en, this message translates to:
  /// **'Gemini™ Pro'**
  String get geminiPro;

  /// Help text for model selection
  ///
  /// In en, this message translates to:
  /// **'Choose the AI model to use for processing'**
  String get chooseAiModelDescription;

  /// Status message for discarded AI actions
  ///
  /// In en, this message translates to:
  /// **'Actions Discarded'**
  String get actionsDiscarded;

  /// Title for weekly insights overview
  ///
  /// In en, this message translates to:
  /// **'Weekly Overview'**
  String get weeklyOverview;

  /// Error message for insights loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading insights'**
  String get errorLoadingInsights;

  /// Message when no items match search criteria
  ///
  /// In en, this message translates to:
  /// **'No matching items found'**
  String get noMatchingItemsFound;

  /// Dialog title for removing item and suggestion
  ///
  /// In en, this message translates to:
  /// **'Remove Item and Suggestion?'**
  String get removeItemAndSuggestion;

  /// Dialog title for removing suggestion only
  ///
  /// In en, this message translates to:
  /// **'Remove Suggestion?'**
  String get removeSuggestion;

  /// Description for removing item and suggestion
  ///
  /// In en, this message translates to:
  /// **'This will remove \"{itemName}\" from your current shopping list and also from your suggestions.'**
  String removeItemAndSuggestionDesc(String itemName);

  /// Description for removing suggestion only
  ///
  /// In en, this message translates to:
  /// **'This will remove \"{itemName}\" from your suggestions. It will not affect your current shopping list.'**
  String removeSuggestionDesc(String itemName);

  /// Button to remove item
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Number of items selected
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String itemsSelected(int count);

  /// Chat screen title with list name
  ///
  /// In en, this message translates to:
  /// **'Chat with {listName}'**
  String chatWith(String listName);

  /// Title for AI suggestions review
  ///
  /// In en, this message translates to:
  /// **'Review AI Suggestions'**
  String get reviewAiSuggestions;

  /// Validation message for AI actions
  ///
  /// In en, this message translates to:
  /// **'Please select at least one action to execute'**
  String get pleaseSelectAtLeastOneAction;

  /// Title for applied AI actions
  ///
  /// In en, this message translates to:
  /// **'Applied Actions'**
  String get appliedActions;

  /// Message when no AI actions were applied
  ///
  /// In en, this message translates to:
  /// **'No actions were applied'**
  String get noActionsWereApplied;

  /// Title for frequently bought items section
  ///
  /// In en, this message translates to:
  /// **'Frequently Bought Items'**
  String get frequentlyBoughtItems;

  /// Placeholder text for item search
  ///
  /// In en, this message translates to:
  /// **'Search item'**
  String get searchItem;

  /// Message when no frequently bought items available
  ///
  /// In en, this message translates to:
  /// **'No frequently bought items'**
  String get noFrequentlyBoughtItems;

  /// Instructions for seeing frequently bought items
  ///
  /// In en, this message translates to:
  /// **'Complete shopping lists to see your most bought items'**
  String get completeListsToSeeMostBought;

  /// Number of times an item was purchased
  ///
  /// In en, this message translates to:
  /// **'Purchased {count} times'**
  String timesPurchased(int count);

  /// Error message for frequently bought items loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading frequently bought items'**
  String get errorLoadingFrequentlyBought;

  /// Generic error message for data loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Description for shopping insights feature
  ///
  /// In en, this message translates to:
  /// **'Discover your shopping patterns'**
  String get discoverShoppingPatterns;

  /// Error message for price history loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading price history'**
  String get errorLoadingPriceHistory;

  /// Message when only one purchase exists for price tracking
  ///
  /// In en, this message translates to:
  /// **'Only one purchase found'**
  String get onlyOnePurchaseFound;

  /// Shows last purchase price
  ///
  /// In en, this message translates to:
  /// **'Last purchased for {price}'**
  String lastPurchasedFor(String price);

  /// Shows purchase date
  ///
  /// In en, this message translates to:
  /// **'Purchased on {date}'**
  String purchasedOn(String date);

  /// Instructions for seeing price trends with multiple purchases
  ///
  /// In en, this message translates to:
  /// **'Purchase this item more times to see price trends'**
  String get purchaseMoreTimesToSeeTrends;

  /// Label for average price
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Label for lowest price
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get lowest;

  /// Label for highest price
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// Hint text for item search field
  ///
  /// In en, this message translates to:
  /// **'Search or add new item...'**
  String get searchOrAddNewItem;

  /// Section header for frequently bought items
  ///
  /// In en, this message translates to:
  /// **'Frequently Bought'**
  String get frequentlyBought;

  /// Error message for search results loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading results: {error}'**
  String errorLoadingResults(String error);

  /// Search results header when no results found
  ///
  /// In en, this message translates to:
  /// **'Search Results (0)'**
  String get searchResultsZero;

  /// Help text for empty search results
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or add \"{searchQuery}\" as a new item'**
  String tryDifferentSearchOrAdd(String searchQuery);

  /// Error message for item loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading item'**
  String get errorLoadingItem;

  /// Error message when item cannot be found
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get itemNotFound;

  /// Confirmation message for item deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{itemName}\"?'**
  String confirmDeleteItem(String itemName);

  /// Label for item quantity field
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Validation message for invalid number input
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// Label for item price field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Label for total amount
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Error message for loading list items
  ///
  /// In en, this message translates to:
  /// **'Could not load shop list\'s items due to an error.'**
  String get errorLoadingShopListItems;

  /// Empty state message for cart
  ///
  /// In en, this message translates to:
  /// **'No items in cart yet'**
  String get noItemsInCartYet;

  /// Encouraging message for empty cart
  ///
  /// In en, this message translates to:
  /// **'Ready to start shopping?'**
  String get readyToStartShopping;

  /// Instructions for cart functionality
  ///
  /// In en, this message translates to:
  /// **'Items you check off will appear here'**
  String get itemsYouCheckOffWillAppearHere;

  /// Instructions for adding first item
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first item'**
  String get tapPlusButtonToAddFirstItem;

  /// Question asking if user needs more items
  ///
  /// In en, this message translates to:
  /// **'Need more items?'**
  String get needMoreItems;

  /// Instructions for adding more items
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add more items'**
  String get tapButtonBelowToAddMoreItems;

  /// Instructions for adding needed items
  ///
  /// In en, this message translates to:
  /// **'Add items you still need to buy'**
  String get addItemsYouStillNeedToBuy;

  /// Instructions for adding first item with button
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first item'**
  String get tapButtonBelowToAddFirstItem;

  /// Instructions for new users
  ///
  /// In en, this message translates to:
  /// **'Add your first item to get started'**
  String get addFirstItemToGetStarted;

  /// Button to generate content
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// AI section or feature label
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get ai;

  /// Button to filter AI models
  ///
  /// In en, this message translates to:
  /// **'Filter Models'**
  String get filterModels;

  /// Filter section for AI thinking capabilities
  ///
  /// In en, this message translates to:
  /// **'Thinking Capabilities'**
  String get thinkingCapabilities;

  /// Filter label for input token limits
  ///
  /// In en, this message translates to:
  /// **'Input Tokens (in millions)'**
  String get inputTokensInMillions;

  /// Label for minimum value input
  ///
  /// In en, this message translates to:
  /// **'Min Value'**
  String get minValue;

  /// Label for maximum value input
  ///
  /// In en, this message translates to:
  /// **'Max Value'**
  String get maxValue;

  /// Filter label for output token limits
  ///
  /// In en, this message translates to:
  /// **'Output Tokens (in millions)'**
  String get outputTokensInMillions;

  /// Filter section for AI temperature settings
  ///
  /// In en, this message translates to:
  /// **'Temperature Range'**
  String get temperatureRange;

  /// Button to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Status message for successfully applied AI actions
  ///
  /// In en, this message translates to:
  /// **'Actions Applied'**
  String get actionsApplied;

  /// Button to apply AI actions
  ///
  /// In en, this message translates to:
  /// **'Apply Actions'**
  String get applyActions;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Instruction to return to home
  ///
  /// In en, this message translates to:
  /// **'Please go back to the home screen'**
  String get pleaseGoBackToHomeScreen;

  /// Chart header for price trends
  ///
  /// In en, this message translates to:
  /// **'Price trend for last purchases'**
  String get priceTrendForLastPurchases;

  /// Warning about excluded settings in backup
  ///
  /// In en, this message translates to:
  /// **'Settings will not be included'**
  String get settingsWillNotBeIncluded;

  /// Success message for snapshot creation
  ///
  /// In en, this message translates to:
  /// **'Snapshot created successfully'**
  String get snapshotCreatedSuccessfully;

  /// Button to create something
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Title for successful snapshot creation
  ///
  /// In en, this message translates to:
  /// **'Snapshot Created'**
  String get snapshotCreated;

  /// Error message for failed snapshot
  ///
  /// In en, this message translates to:
  /// **'Snapshot failed: {error}'**
  String snapshotFailed(String error);

  /// Button to restore backup
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Section title for manual backups
  ///
  /// In en, this message translates to:
  /// **'Manual Snapshots'**
  String get manualSnapshots;

  /// Dialog title for restoring backup
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// Option to replace data during restore
  ///
  /// In en, this message translates to:
  /// **'Replace existing data'**
  String get replaceExistingData;

  /// Warning about clearing data before restore
  ///
  /// In en, this message translates to:
  /// **'Clear all current data before restoring'**
  String get clearCurrentDataBeforeRestoring;

  /// Error message for failed restore
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// Instructions for export options
  ///
  /// In en, this message translates to:
  /// **'Choose what to include'**
  String get chooseWhatToInclude;

  /// Option for complete data export
  ///
  /// In en, this message translates to:
  /// **'Full Export'**
  String get fullExport;

  /// Option for database-only export
  ///
  /// In en, this message translates to:
  /// **'Database Only'**
  String get databaseOnly;

  /// Button to create backup snapshot
  ///
  /// In en, this message translates to:
  /// **'Create Snapshot'**
  String get createSnapshot;

  /// Button to indicate completion
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Warning about clearing data before import
  ///
  /// In en, this message translates to:
  /// **'Clear all current data before importing'**
  String get clearAllCurrentDataBeforeImporting;

  /// Title for successful restore
  ///
  /// In en, this message translates to:
  /// **'Restore Successful'**
  String get restoreSuccessful;

  /// Filter button text with count
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String filtersWithCount(int count);

  /// Button to filter results
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Button to clear all applied filters
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorWithDetails(String details);

  /// Label for creation date
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Label for file size
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Important notice header
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// Warning message for data replacement during restore
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all current data and replace it with the backup data.'**
  String get dataReplacementWarning;

  /// Warning message for data merging during restore
  ///
  /// In en, this message translates to:
  /// **'This will merge the backup data with your current data. Duplicates may occur.'**
  String get dataMergeWarning;

  /// Success message for data restore
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get dataRestoredSuccessfully;

  /// Success message for data merge
  ///
  /// In en, this message translates to:
  /// **'Backup data merged successfully'**
  String get backupDataMergedSuccessfully;

  /// Header for quick export options
  ///
  /// In en, this message translates to:
  /// **'Quick Options'**
  String get quickOptions;

  /// Label for shopping lists data
  ///
  /// In en, this message translates to:
  /// **'Shopping Lists'**
  String get shoppingLists;

  /// Header for backup file information
  ///
  /// In en, this message translates to:
  /// **'Backup Information'**
  String get backupInformation;

  /// Label for file name
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// Label for settings inclusion status
  ///
  /// In en, this message translates to:
  /// **'Includes Settings'**
  String get includesSettings;

  /// Header for import configuration options
  ///
  /// In en, this message translates to:
  /// **'Import Options'**
  String get importOptions;

  /// Detailed success message for data restore
  ///
  /// In en, this message translates to:
  /// **'Your data has been restored successfully.'**
  String get dataRestoredSuccessfullyMessage;

  /// Detailed success message for data merge
  ///
  /// In en, this message translates to:
  /// **'The backup data has been merged with your current data successfully.'**
  String get backupDataMergedSuccessfullyMessage;

  /// Title for AI assistant setup section
  ///
  /// In en, this message translates to:
  /// **'AI Assistant Configuration'**
  String get aiAssistantConfiguration;

  /// Description for AI assistant configuration
  ///
  /// In en, this message translates to:
  /// **'Configure your AI assistant to help manage shopping lists and provide suggestions.'**
  String get configureAiAssistantDescription;

  /// Title for API configuration section
  ///
  /// In en, this message translates to:
  /// **'API Configuration'**
  String get apiConfiguration;

  /// Description for API key setup
  ///
  /// In en, this message translates to:
  /// **'Set up your Google™ Gemini™ API key to enable AI features'**
  String get setupGeminiApiKeyDescription;

  /// Title for connection status section
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Title for Gemini information section
  ///
  /// In en, this message translates to:
  /// **'About Google™ Gemini™'**
  String get aboutGoogleGemini;

  /// Information about getting API key
  ///
  /// In en, this message translates to:
  /// **'Get your free API key from Google™ AI Studio'**
  String get getFreeApiKeyFromGoogleAi;

  /// Information about AI features
  ///
  /// In en, this message translates to:
  /// **'AI features include chat assistance and smart suggestions'**
  String get aiFeaturesIncludeChatAndSuggestions;

  /// Security information about API key storage
  ///
  /// In en, this message translates to:
  /// **'Your API key is stored securely on your device'**
  String get apiKeyStoredSecurely;

  /// Information about API rate limits
  ///
  /// In en, this message translates to:
  /// **'API usage may be subject to Google™\'s rate limits'**
  String get apiUsageSubjectToRateLimits;

  /// Legal disclaimer about Google trademarks
  ///
  /// In en, this message translates to:
  /// **'Google™ and Gemini™ are trademarks of Google LLC. This app is not affiliated with Google.'**
  String get googleTrademarkDisclaimer;

  /// Title for automatic backup section
  ///
  /// In en, this message translates to:
  /// **'Automatic Backup'**
  String get automaticBackup;

  /// Description for automatic backup feature
  ///
  /// In en, this message translates to:
  /// **'Your data is automatically backed up to Google Drive'**
  String get dataAutomaticallyBackedUpToDrive;

  /// Status message for enabled automatic backup
  ///
  /// In en, this message translates to:
  /// **'Automatic backup is enabled and working'**
  String get automaticBackupEnabledAndWorking;

  /// Status message for detected backup configuration
  ///
  /// In en, this message translates to:
  /// **'Automatic backup configuration detected'**
  String get automaticBackupConfigurationDetected;

  /// Information about how automatic backup works
  ///
  /// In en, this message translates to:
  /// **'Automatic backup runs periodically in the background. Manual snapshots work locally, but won\'t survive app uninstalls until automatic backup has synced them to Google Drive.'**
  String get automaticBackupInfoMessage;

  /// Title for backup information section
  ///
  /// In en, this message translates to:
  /// **'How Backup Works'**
  String get howBackupWorks;

  /// Information about automatic backup sync
  ///
  /// In en, this message translates to:
  /// **'Automatic backup syncs your data to Google Drive'**
  String get automaticBackupSyncsToGoogleDrive;

  /// Information about manual snapshot storage
  ///
  /// In en, this message translates to:
  /// **'Manual snapshots are stored locally and included in automatic sync'**
  String get manualSnapshotsStoredLocallyAndSynced;

  /// Warning about data replacement during restore
  ///
  /// In en, this message translates to:
  /// **'Restoring will replace your current data'**
  String get restoringWillReplaceCurrentData;

  /// Information about what is included in backups
  ///
  /// In en, this message translates to:
  /// **'Backups include shopping lists, chat history, and optionally settings'**
  String get backupsIncludeShoppingListsChatAndSettings;

  /// Message when no manual snapshots exist
  ///
  /// In en, this message translates to:
  /// **'No manual snapshots yet'**
  String get noManualSnapshotsYet;

  /// Instructions for creating manual snapshots
  ///
  /// In en, this message translates to:
  /// **'Create a manual snapshot to have additional control over your data'**
  String get createManualSnapshotForAdditionalControl;

  /// Description for manual backup section
  ///
  /// In en, this message translates to:
  /// **'Create and manage additional snapshot files'**
  String get createAndManageAdditionalSnapshotFiles;

  /// Label for AI thinking capability filter
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get thinking;

  /// Label for input tokens
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// Label for output tokens
  ///
  /// In en, this message translates to:
  /// **'Output'**
  String get output;

  /// Label for AI temperature setting
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Unit for token counts (millions)
  ///
  /// In en, this message translates to:
  /// **'M tokens'**
  String get tokensUnit;

  /// Prefix text for active filters display
  ///
  /// In en, this message translates to:
  /// **'Filtered by'**
  String get filteredBy;

  /// Button to clear filters or selections
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Confirmation message for deleting shopping list
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the shop list \"{listName}\"?'**
  String confirmDeleteShopList(String listName);

  /// Title for empty shopping lists state
  ///
  /// In en, this message translates to:
  /// **'No Shopping Lists Yet'**
  String get noShoppingListsYet;

  /// Description for empty shopping lists state
  ///
  /// In en, this message translates to:
  /// **'Create your first shopping list above to start organizing your groceries and never forget an item again!'**
  String get createFirstShoppingListDescription;

  /// Header for recent shopping lists section
  ///
  /// In en, this message translates to:
  /// **'Recent Lists'**
  String get recentLists;

  /// Count of items currently displayed
  ///
  /// In en, this message translates to:
  /// **'{count} shown'**
  String itemsShown(int count);

  /// Progress indicator showing completed items
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} items completed'**
  String itemsCompleted(int completed, int total);

  /// Button text for continuing shopping on incomplete list
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// Button text for viewing completed list
  ///
  /// In en, this message translates to:
  /// **'View List'**
  String get viewList;

  /// Progress text showing items completed
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} items'**
  String itemsProgress(int completed, int total);

  /// Label for remaining items section
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Header label for all items section
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// Header label for all items section with count
  ///
  /// In en, this message translates to:
  /// **'All Items ({count})'**
  String allItemsWithCount(int count);

  /// Status message for connected API
  ///
  /// In en, this message translates to:
  /// **'API Connected'**
  String get apiConnected;

  /// Generic connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Connected status with available models count
  ///
  /// In en, this message translates to:
  /// **'Connected ({count} models available)'**
  String connectedWithModels(int count);

  /// Status message while verifying API key
  ///
  /// In en, this message translates to:
  /// **'Verifying API Key...'**
  String get verifyingApiKey;

  /// Status message while checking Gemini API connection
  ///
  /// In en, this message translates to:
  /// **'Checking connection to Gemini API...'**
  String get checkingConnectionGemini;

  /// Title for shopping list management
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageList;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
