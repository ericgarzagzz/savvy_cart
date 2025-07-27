// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SavvyCart';

  @override
  String get appSubtitle => 'Умные списки покупок';

  @override
  String get settingsTitle => 'Настройки SavvyCart';

  @override
  String chatWithList(String listName) {
    return 'Чат со списком \"$listName\"';
  }

  @override
  String get searchItemPrice => 'Поиск цены товара';

  @override
  String get backupAndRestore => 'Резервное копирование и восстановление';

  @override
  String get shoppingInsights => 'Аналитика покупок';

  @override
  String get searchLists => 'Поиск списков';

  @override
  String get selectGeminiModel => 'Выбрать модель Gemini™';

  @override
  String get aiSettings => 'Настройки ИИ';

  @override
  String get addItem => 'Добавить товар';

  @override
  String get createShoppingList => 'Создать список покупок';

  @override
  String get createNewList => 'Создать новый список';

  @override
  String get loadMore => 'Загрузить ещё';

  @override
  String get executeSelectedActions => 'Выполнить выбранные действия';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get apply => 'Применить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get close => 'Закрыть';

  @override
  String get goHome => 'На главную';

  @override
  String get goToHomePage => 'Перейти на главную страницу';

  @override
  String get enterListName => 'Введите название списка';

  @override
  String get listName => 'Название списка';

  @override
  String get itemName => 'Название товара';

  @override
  String get enterItemName => 'Введите название товара...';

  @override
  String get searchByListName => 'Поиск по названию списка...';

  @override
  String get typeYourMessage => 'Введите ваше сообщение...';

  @override
  String get geminiApiKey => 'API-ключ Google™ Gemini™';

  @override
  String get geminiModel => 'Модель Gemini™';

  @override
  String get listNameCannotBeEmpty => 'Название списка не может быть пустым';

  @override
  String get aiAssistant => 'ИИ-помощник';

  @override
  String get data => 'Данные';

  @override
  String get localization => 'Локализация';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get systemLanguage => 'Системный язык';

  @override
  String get autoDetectFromDeviceSettings =>
      'Автоопределение из настроек устройства';

  @override
  String get developer => 'Разработчик';

  @override
  String get generateMockData => 'Создать тестовые данные';

  @override
  String get deleteDatabase => 'Удалить базу данных';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get ready => 'Готов';

  @override
  String get notVerified => 'Не проверен';

  @override
  String get notConfigured => 'Не настроен';

  @override
  String get manageBackups => 'Управление резервными копиями';

  @override
  String get addSampleShoppingLists => 'Добавить примеры списков покупок';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get loading => 'Загрузка...';

  @override
  String get recommended => 'Рекомендуется';

  @override
  String get deleteShopList => 'Удалить список покупок';

  @override
  String get editItemName => 'Изменить название товара';

  @override
  String get deleteItem => 'Удалить товар';

  @override
  String get deleteBackup => 'Удалить резервную копию';

  @override
  String get createManualSnapshot => 'Создать ручной снимок';

  @override
  String get error => 'Ошибка';

  @override
  String get toBuy => 'К покупке';

  @override
  String get inCart => 'В корзине';

  @override
  String get listsCreated => 'Создано списков';

  @override
  String get totalSpent => 'Всего потрачено';

  @override
  String get filterByDateRange => 'Фильтр по диапазону дат';

  @override
  String get startDate => 'Дата начала';

  @override
  String get endDate => 'Дата окончания';

  @override
  String get tokenLimits => 'Лимиты токенов';

  @override
  String get all => 'Все';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String searchResultsCount(int count) {
    return 'Результаты поиска ($count)';
  }

  @override
  String get noShoppingDataYet => 'Пока нет данных о покупках';

  @override
  String get createFirstListDescription =>
      'Создайте первый список покупок, чтобы начать отслеживать аналитику ваших покупательских привычек и трат.';

  @override
  String get noItemsFound => 'Товары не найдены';

  @override
  String tryDifferentSearchTerm(String searchQuery) {
    return 'Попробуйте другой поисковый запрос или добавьте \"$searchQuery\" как новый товар';
  }

  @override
  String get noPriceHistoryAvailable => 'История цен недоступна';

  @override
  String get purchaseItemToTrackPrice =>
      'Купите этот товар, чтобы начать отслеживать динамику его цены';

  @override
  String get noListsFound => 'Списки не найдены';

  @override
  String get tryAdjustingFilters =>
      'Попробуйте изменить условия поиска или фильтры дат';

  @override
  String get loadingAvailableModels => 'Загрузка доступных моделей...';

  @override
  String failedToRemoveItem(String error) {
    return 'Не удалось удалить товар: $error';
  }

  @override
  String get couldNotLoadShopListItems =>
      'Не удалось загрузить товары списка покупок из-за ошибки.';

  @override
  String get errorLoadingSearchResults => 'Ошибка загрузки результатов поиска';

  @override
  String get pleaseTryAgainLater => 'Пожалуйста, попробуйте снова позже';

  @override
  String get errorLoadingSuggestions => 'Ошибка загрузки предложений';

  @override
  String failedToLoadBackupInfo(String error) {
    return 'Не удалось загрузить информацию о резервной копии: $error';
  }

  @override
  String pageNotFound(String uri) {
    return 'Страница не найдена: $uri';
  }

  @override
  String get invalidShopListId => 'Неверный ID списка покупок';

  @override
  String get invalidItemName => 'Неверное название товара';

  @override
  String badRequest(String responseBody) {
    return 'Неверный запрос: $responseBody';
  }

  @override
  String get invalidApiKeyOrAuth =>
      'Неверный API-ключ или ошибка аутентификации';

  @override
  String get accessForbidden => 'Доступ запрещён - проверьте разрешения API';

  @override
  String get apiRateLimitExceeded =>
      'Превышен лимит API. Пожалуйста, попробуйте снова позже.';

  @override
  String get internalServerError => 'Внутренняя ошибка сервера';

  @override
  String get badGateway => 'Неверный шлюз - сервис временно недоступен';

  @override
  String get serviceUnavailable => 'Сервис недоступен';

  @override
  String get gatewayTimeout => 'Тайм-аут шлюза';

  @override
  String get noInternetConnection => 'Нет подключения к интернету';

  @override
  String get requestTimedOut => 'Истекло время ожидания запроса';

  @override
  String get invalidResponseFormat => 'Неверный формат ответа API';

  @override
  String get generatingMockData => 'Создание тестовых данных...';

  @override
  String get mockDataGeneratedSuccessfully =>
      'Тестовые данные успешно созданы!';

  @override
  String errorGeneratingMockData(String error) {
    return 'Ошибка создания тестовых данных: $error';
  }

  @override
  String get databaseDeletedSuccessfully => 'База данных успешно удалена';

  @override
  String errorDeletingDatabase(String error) {
    return 'Ошибка удаления базы данных: $error';
  }

  @override
  String get backupDeletedSuccessfully => 'Резервная копия успешно удалена';

  @override
  String failedToDeleteBackup(String error) {
    return 'Не удалось удалить резервную копию: $error';
  }

  @override
  String get pleaseEnterValidApiKey =>
      'Пожалуйста, сначала введите действительный API-ключ';

  @override
  String get processing => 'Обработка...';

  @override
  String get startYourShoppingJourney => 'Начните свой путь покупок';

  @override
  String get searchForItemViewHistory =>
      'Найдите товар, чтобы просмотреть историю его цен';

  @override
  String get orChooseFromPreviousItems =>
      'Или выберите из ваших предыдущих товаров:';

  @override
  String get searchResults => 'Результаты поиска:';

  @override
  String get addItemsToSeeHere =>
      'Добавьте товары в свои списки покупок, чтобы увидеть их здесь';

  @override
  String tryDifferentSearchOrCreate(String searchQuery) {
    return 'Попробуйте другой поисковый запрос или создайте график для \"$searchQuery\"';
  }

  @override
  String get areYouSureDeleteBackup =>
      'Вы уверены, что хотите удалить эту резервную копию?';

  @override
  String get mockDataGenerationDescription =>
      'Это создаст примеры списков покупок с товарами на протяжении года для тестирования аналитики. Это может занять несколько минут.';

  @override
  String get databaseDeletionWarning =>
      'Это безвозвратно удалит все ваши данные, включая списки покупок, товары и настройки. Это действие нельзя отменить.';

  @override
  String get shoppingListsAlwaysIncluded => 'Списки покупок (всегда включены)';

  @override
  String get chooseAdditionalData =>
      'Выберите дополнительные данные для включения:';

  @override
  String get settings => 'Настройки';

  @override
  String get chatHistory => 'История чата';

  @override
  String get suggestions => 'Предложения';

  @override
  String addSearchQuery(String searchQuery) {
    return 'Добавить \"$searchQuery\"';
  }

  @override
  String viewChartFor(String searchQuery) {
    return 'Посмотреть график для \"$searchQuery\"';
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
  String get chooseAiModelDescription => 'Выберите модель ИИ для обработки';

  @override
  String get actionsDiscarded => 'Действия отменены';

  @override
  String get weeklyOverview => 'Недельный обзор';

  @override
  String get errorLoadingInsights => 'Ошибка загрузки аналитики';

  @override
  String get noMatchingItemsFound => 'Подходящие товары не найдены';

  @override
  String get removeItemAndSuggestion => 'Удалить товар и предложение?';

  @override
  String get removeSuggestion => 'Удалить предложение?';

  @override
  String removeItemAndSuggestionDesc(String itemName) {
    return 'Это удалит \"$itemName\" из вашего текущего списка покупок, а также из ваших предложений.';
  }

  @override
  String removeSuggestionDesc(String itemName) {
    return 'Это удалит \"$itemName\" из ваших предложений. Это не повлияет на ваш текущий список покупок.';
  }

  @override
  String get remove => 'Удалить';

  @override
  String itemsSelected(int count) {
    return 'Выбрано: $count';
  }

  @override
  String chatWith(String listName) {
    return 'Чат с $listName';
  }

  @override
  String get reviewAiSuggestions => 'Проверить предложения ИИ';

  @override
  String get pleaseSelectAtLeastOneAction =>
      'Пожалуйста, выберите хотя бы одно действие для выполнения';

  @override
  String get appliedActions => 'Применённые действия';

  @override
  String get noActionsWereApplied => 'Никаких действий не было применено';

  @override
  String get frequentlyBoughtItems => 'Часто покупаемые товары';

  @override
  String get searchItem => 'Найти товар';

  @override
  String get noFrequentlyBoughtItems => 'Нет часто покупаемых товаров';

  @override
  String get completeListsToSeeMostBought =>
      'Завершите списки покупок, чтобы увидеть ваши самые покупаемые товары';

  @override
  String timesPurchased(int count) {
    return 'Куплено $count раз';
  }

  @override
  String get errorLoadingFrequentlyBought =>
      'Ошибка загрузки часто покупаемых товаров';

  @override
  String get errorLoadingData => 'Ошибка загрузки данных';

  @override
  String get discoverShoppingPatterns => 'Изучите ваши покупательские привычки';

  @override
  String get errorLoadingPriceHistory => 'Ошибка загрузки истории цен';

  @override
  String get onlyOnePurchaseFound => 'Найдена только одна покупка';

  @override
  String lastPurchasedFor(String price) {
    return 'Последняя покупка за $price';
  }

  @override
  String purchasedOn(String date) {
    return 'Куплено $date';
  }

  @override
  String get purchaseMoreTimesToSeeTrends =>
      'Купите этот товар ещё несколько раз, чтобы увидеть динамику цен';

  @override
  String get average => 'Средняя';

  @override
  String get lowest => 'Минимальная';

  @override
  String get highest => 'Максимальная';

  @override
  String get searchOrAddNewItem => 'Найти или добавить новый товар...';

  @override
  String get frequentlyBought => 'Часто покупаемые';

  @override
  String errorLoadingResults(String error) {
    return 'Ошибка загрузки результатов: $error';
  }

  @override
  String get searchResultsZero => 'Результаты поиска (0)';

  @override
  String tryDifferentSearchOrAdd(String searchQuery) {
    return 'Попробуйте другой поисковый запрос или добавьте \"$searchQuery\" как новый товар';
  }

  @override
  String get errorLoadingItem => 'Ошибка загрузки товара';

  @override
  String get itemNotFound => 'Товар не найден';

  @override
  String confirmDeleteItem(String itemName) {
    return 'Вы уверены, что хотите удалить \"$itemName\"?';
  }

  @override
  String get quantity => 'Количество';

  @override
  String get required => 'Обязательно';

  @override
  String get invalidNumber => 'Неверное число';

  @override
  String get price => 'Цена';

  @override
  String get total => 'Итого';

  @override
  String get errorLoadingShopListItems =>
      'Не удалось загрузить товары списка покупок из-за ошибки.';

  @override
  String get noItemsInCartYet => 'В корзине пока нет товаров';

  @override
  String get readyToStartShopping => 'Готовы начать покупки?';

  @override
  String get itemsYouCheckOffWillAppearHere =>
      'Товары, которые вы отметите, появятся здесь';

  @override
  String get tapPlusButtonToAddFirstItem =>
      'Нажмите кнопку + ниже, чтобы добавить первый товар';

  @override
  String get needMoreItems => 'Нужны ещё товары?';

  @override
  String get tapButtonBelowToAddMoreItems =>
      'Нажмите кнопку ниже, чтобы добавить больше товаров';

  @override
  String get addItemsYouStillNeedToBuy =>
      'Добавьте товары, которые вам ещё нужно купить';

  @override
  String get tapButtonBelowToAddFirstItem =>
      'Нажмите кнопку ниже, чтобы добавить первый товар';

  @override
  String get addFirstItemToGetStarted => 'Добавьте первый товар, чтобы начать';

  @override
  String get generate => 'Создать';

  @override
  String get ai => 'ИИ';

  @override
  String get filterModels => 'Фильтр моделей';

  @override
  String get thinkingCapabilities => 'Возможности мышления';

  @override
  String get inputTokensInMillions => 'Входные токены (в миллионах)';

  @override
  String get minValue => 'Мин. значение';

  @override
  String get maxValue => 'Макс. значение';

  @override
  String get outputTokensInMillions => 'Выходные токены (в миллионах)';

  @override
  String get temperatureRange => 'Диапазон температуры';

  @override
  String get retry => 'Повторить';

  @override
  String get actionsApplied => 'Действия применены';

  @override
  String get applyActions => 'Применить действия';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get pleaseGoBackToHomeScreen =>
      'Пожалуйста, вернитесь на главный экран';

  @override
  String get priceTrendForLastPurchases => 'Динамика цен для последних покупок';

  @override
  String get settingsWillNotBeIncluded => 'Настройки не будут включены';

  @override
  String get snapshotCreatedSuccessfully => 'Снимок успешно создан';

  @override
  String get create => 'Создать';

  @override
  String get snapshotCreated => 'Снимок создан';

  @override
  String snapshotFailed(String error) {
    return 'Создание снимка не удалось: $error';
  }

  @override
  String get restore => 'Восстановить';

  @override
  String get manualSnapshots => 'Ручные снимки';

  @override
  String get restoreBackup => 'Восстановить резервную копию';

  @override
  String get replaceExistingData => 'Заменить существующие данные';

  @override
  String get clearCurrentDataBeforeRestoring =>
      'Очистить все текущие данные перед восстановлением';

  @override
  String restoreFailed(String error) {
    return 'Восстановление не удалось: $error';
  }

  @override
  String get chooseWhatToInclude => 'Выберите, что включить';

  @override
  String get fullExport => 'Полный экспорт';

  @override
  String get databaseOnly => 'Только база данных';

  @override
  String get createSnapshot => 'Создать снимок';

  @override
  String get done => 'Готово';

  @override
  String get clearAllCurrentDataBeforeImporting =>
      'Очистить все текущие данные перед импортом';

  @override
  String get restoreSuccessful => 'Восстановление успешно';

  @override
  String filtersWithCount(int count) {
    return 'Фильтры ($count)';
  }

  @override
  String get filter => 'Фильтр';

  @override
  String get clearAllFilters => 'Очистить все фильтры';

  @override
  String errorWithDetails(String details) {
    return 'Ошибка: $details';
  }

  @override
  String get created => 'Создано';

  @override
  String get size => 'Размер';

  @override
  String get important => 'Важно';

  @override
  String get dataReplacementWarning =>
      'Это безвозвратно удалит все текущие данные и заменит их данными из резервной копии.';

  @override
  String get dataMergeWarning =>
      'Это объединит данные из резервной копии с вашими текущими данными. Могут появиться дублирующиеся записи.';

  @override
  String get dataRestoredSuccessfully => 'Данные успешно восстановлены';

  @override
  String get backupDataMergedSuccessfully =>
      'Данные из резервной копии успешно объединены';

  @override
  String get quickOptions => 'Быстрые параметры';

  @override
  String get shoppingLists => 'Списки покупок';

  @override
  String get backupInformation => 'Информация о резервной копии';

  @override
  String get file => 'Файл';

  @override
  String get includesSettings => 'Включает настройки';

  @override
  String get importOptions => 'Параметры импорта';

  @override
  String get dataRestoredSuccessfullyMessage =>
      'Ваши данные были успешно восстановлены.';

  @override
  String get backupDataMergedSuccessfullyMessage =>
      'Данные из резервной копии были успешно объединены с вашими текущими данными.';

  @override
  String get aiAssistantConfiguration => 'Настройка ИИ-помощника';

  @override
  String get configureAiAssistantDescription =>
      'Настройте вашего ИИ-помощника для управления списками покупок и получения предложений.';

  @override
  String get apiConfiguration => 'Настройка API';

  @override
  String get setupGeminiApiKeyDescription =>
      'Настройте ваш API-ключ Google™ Gemini™ для включения функций ИИ';

  @override
  String get connectionStatus => 'Статус соединения';

  @override
  String get aboutGoogleGemini => 'О Google™ Gemini™';

  @override
  String get getFreeApiKeyFromGoogleAi =>
      'Получите бесплатный API-ключ в Google™ AI Studio';

  @override
  String get aiFeaturesIncludeChatAndSuggestions =>
      'Функции ИИ включают помощь в чате и умные предложения';

  @override
  String get apiKeyStoredSecurely =>
      'Ваш API-ключ надёжно хранится на вашем устройстве';

  @override
  String get apiUsageSubjectToRateLimits =>
      'Использование API может подлежать ограничениям скорости Google™';

  @override
  String get googleTrademarkDisclaimer =>
      'Google™ и Gemini™ являются торговыми марками Google LLC. Это приложение не связано с Google.';

  @override
  String get automaticBackup => 'Автоматическое резервное копирование';

  @override
  String get dataAutomaticallyBackedUpToDrive =>
      'Ваши данные автоматически сохраняются в Google Drive';

  @override
  String get automaticBackupEnabledAndWorking =>
      'Автоматическое резервное копирование включено и работает';

  @override
  String get automaticBackupConfigurationDetected =>
      'Обнаружена конфигурация автоматического резервного копирования';

  @override
  String get automaticBackupInfoMessage =>
      'Автоматическое резервное копирование выполняется периодически в фоновом режиме. Ручные снимки работают локально, но не сохранятся при удалении приложения до тех пор, пока автоматическое резервное копирование не синхронизирует их с Google Drive.';

  @override
  String get howBackupWorks => 'Как работает резервное копирование';

  @override
  String get automaticBackupSyncsToGoogleDrive =>
      'Автоматическое резервное копирование синхронизирует ваши данные с Google Drive';

  @override
  String get manualSnapshotsStoredLocallyAndSynced =>
      'Ручные снимки хранятся локально и включаются в автоматическую синхронизацию';

  @override
  String get restoringWillReplaceCurrentData =>
      'Восстановление заменит ваши текущие данные';

  @override
  String get backupsIncludeShoppingListsChatAndSettings =>
      'Резервные копии включают списки покупок, историю чата и, опционально, настройки';

  @override
  String get noManualSnapshotsYet => 'Пока нет ручных снимков';

  @override
  String get createManualSnapshotForAdditionalControl =>
      'Создайте ручной снимок для дополнительного контроля над вашими данными';

  @override
  String get createAndManageAdditionalSnapshotFiles =>
      'Создание и управление дополнительными файлами снимков';

  @override
  String get thinking => 'Мышление';

  @override
  String get input => 'Вход';

  @override
  String get output => 'Выход';

  @override
  String get temperature => 'Температура';

  @override
  String get tokensUnit => 'млн токенов';

  @override
  String get filteredBy => 'Фильтр по';

  @override
  String get clear => 'Очистить';

  @override
  String confirmDeleteShopList(String listName) {
    return 'Вы уверены, что хотите удалить список покупок \"$listName\"?';
  }

  @override
  String get noShoppingListsYet => 'Пока нет списков покупок';

  @override
  String get createFirstShoppingListDescription =>
      'Создайте ваш первый список покупок выше, чтобы начать организовывать ваши продукты и никогда не забыть ни одного товара!';

  @override
  String get recentLists => 'Недавние списки';

  @override
  String itemsShown(int count) {
    return 'Показано: $count';
  }

  @override
  String itemsCompleted(int completed, int total) {
    return 'Выполнено $completed из $total товаров';
  }

  @override
  String get continueShopping => 'Продолжить покупки';

  @override
  String get viewList => 'Просмотреть список';

  @override
  String itemsProgress(int completed, int total) {
    return '$completed из $total товаров';
  }

  @override
  String get remaining => 'Осталось';

  @override
  String get allItems => 'Все товары';

  @override
  String allItemsWithCount(int count) {
    return 'Все товары ($count)';
  }

  @override
  String get apiConnected => 'API подключен';

  @override
  String get connected => 'Подключено';

  @override
  String connectedWithModels(int count) {
    return 'Подключено (доступно моделей: $count)';
  }

  @override
  String get verifyingApiKey => 'Проверка API-ключа...';

  @override
  String get checkingConnectionGemini => 'Проверка соединения с Gemini API...';

  @override
  String get manageList => 'Управление';

  @override
  String get licenses => 'Лицензии';
}
