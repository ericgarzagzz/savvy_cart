// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SavvyCart';

  @override
  String get appSubtitle => 'Listas de Compras Inteligentes';

  @override
  String get settingsTitle => 'Configuración de SavvyCart';

  @override
  String chatWithList(String listName) {
    return 'Chatear con $listName';
  }

  @override
  String get searchItemPrice => 'Buscar Precio del Artículo';

  @override
  String get backupAndRestore => 'Respaldo y Restauración';

  @override
  String get shoppingInsights => 'Información de Compras';

  @override
  String get searchLists => 'Buscar Listas';

  @override
  String get selectGeminiModel => 'Seleccionar Modelo Gemini™';

  @override
  String get aiSettings => 'Configuración de IA';

  @override
  String get addItem => 'Agregar Artículo';

  @override
  String get createShoppingList => 'Crear Lista de Compras';

  @override
  String get createNewList => 'Crear Nueva Lista';

  @override
  String get loadMore => 'Cargar Más';

  @override
  String get executeSelectedActions => 'Ejecutar Acciones Seleccionadas';

  @override
  String get clearAll => 'Limpiar Todo';

  @override
  String get apply => 'Aplicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Cerrar';

  @override
  String get goHome => 'Ir al Inicio';

  @override
  String get goToHomePage => 'Ir a la Página de Inicio';

  @override
  String get enterListName => 'Ingresa el nombre de la lista';

  @override
  String get listName => 'Nombre de la Lista';

  @override
  String get itemName => 'Nombre del Artículo';

  @override
  String get enterItemName => 'Ingresa el nombre del artículo...';

  @override
  String get searchByListName => 'Buscar por nombre de lista...';

  @override
  String get typeYourMessage => 'Escribe tu mensaje...';

  @override
  String get geminiApiKey => 'Clave API de Google™ Gemini™';

  @override
  String get geminiModel => 'Modelo Gemini™';

  @override
  String get listNameCannotBeEmpty =>
      'El nombre de la lista no puede estar vacío';

  @override
  String get aiAssistant => 'Asistente de IA';

  @override
  String get data => 'Datos';

  @override
  String get localization => 'Localización';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get systemLanguage => 'Idioma del Sistema';

  @override
  String get autoDetectFromDeviceSettings =>
      'Detectar automáticamente desde la configuración del dispositivo';

  @override
  String get developer => 'Desarrollador';

  @override
  String get generateMockData => 'Generar Datos de Prueba';

  @override
  String get deleteDatabase => 'Eliminar Base de Datos';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get ready => 'Listo';

  @override
  String get notVerified => 'No verificado';

  @override
  String get notConfigured => 'No configurado';

  @override
  String get manageBackups => 'Administrar respaldos';

  @override
  String get addSampleShoppingLists => 'Agregar listas de compras de ejemplo';

  @override
  String get clearAllData => 'Limpiar todos los datos';

  @override
  String get loading => 'Cargando...';

  @override
  String get recommended => 'Recomendado';

  @override
  String get deleteShopList => 'Eliminar lista de compras';

  @override
  String get editItemName => 'Editar Nombre del Artículo';

  @override
  String get deleteItem => 'Eliminar Artículo';

  @override
  String get deleteBackup => 'Eliminar Respaldo';

  @override
  String get createManualSnapshot => 'Crear Instantánea Manual';

  @override
  String get error => 'Error';

  @override
  String get toBuy => 'Por Comprar';

  @override
  String get inCart => 'En el Carrito';

  @override
  String get listsCreated => 'Listas Creadas';

  @override
  String get totalSpent => 'Total Gastado';

  @override
  String get filterByDateRange => 'Filtrar por Rango de Fechas';

  @override
  String get startDate => 'Fecha de Inicio';

  @override
  String get endDate => 'Fecha Final';

  @override
  String get tokenLimits => 'Límites de Tokens';

  @override
  String get all => 'Todos';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String searchResultsCount(int count) {
    return 'Resultados de Búsqueda ($count)';
  }

  @override
  String get noShoppingDataYet => 'Aún No Hay Datos de Compras';

  @override
  String get createFirstListDescription =>
      'Crea tu primera lista de compras para comenzar a rastrear información sobre tus patrones de compra y hábitos de gasto.';

  @override
  String get noItemsFound => 'No se encontraron artículos';

  @override
  String tryDifferentSearchTerm(String searchQuery) {
    return 'Intenta con un término de búsqueda diferente o agrega \"$searchQuery\" como un nuevo artículo';
  }

  @override
  String get noPriceHistoryAvailable =>
      'No hay historial de precios disponible';

  @override
  String get purchaseItemToTrackPrice =>
      'Compra este artículo para comenzar a rastrear sus tendencias de precio';

  @override
  String get noListsFound => 'No se encontraron listas';

  @override
  String get tryAdjustingFilters =>
      'Intenta ajustar tus términos de búsqueda o filtros de fecha';

  @override
  String get loadingAvailableModels => 'Cargando modelos disponibles...';

  @override
  String failedToRemoveItem(String error) {
    return 'Error al eliminar artículo: $error';
  }

  @override
  String get couldNotLoadShopListItems =>
      'No se pudieron cargar los artículos de la lista de compras debido a un error.';

  @override
  String get errorLoadingSearchResults =>
      'Error al cargar resultados de búsqueda';

  @override
  String get pleaseTryAgainLater => 'Por favor intenta de nuevo más tarde';

  @override
  String get errorLoadingSuggestions => 'Error al cargar sugerencias';

  @override
  String failedToLoadBackupInfo(String error) {
    return 'Error al cargar información del respaldo: $error';
  }

  @override
  String pageNotFound(String uri) {
    return 'Página no encontrada: $uri';
  }

  @override
  String get invalidShopListId => 'ID de lista de compras inválido';

  @override
  String get invalidItemName => 'Nombre de artículo inválido';

  @override
  String badRequest(String responseBody) {
    return 'Solicitud incorrecta: $responseBody';
  }

  @override
  String get invalidApiKeyOrAuth =>
      'Clave API inválida o falló la autenticación';

  @override
  String get accessForbidden =>
      'Acceso prohibido - verifica los permisos de la API';

  @override
  String get apiRateLimitExceeded =>
      'Límite de velocidad de la API excedido. Por favor intenta de nuevo más tarde.';

  @override
  String get internalServerError => 'Error interno del servidor';

  @override
  String get badGateway =>
      'Gateway incorrecto - servicio temporalmente no disponible';

  @override
  String get serviceUnavailable => 'Servicio no disponible';

  @override
  String get gatewayTimeout => 'Tiempo de espera del gateway agotado';

  @override
  String get noInternetConnection => 'No hay conexión a internet disponible';

  @override
  String get requestTimedOut => 'Se agotó el tiempo de espera de la solicitud';

  @override
  String get invalidResponseFormat => 'Formato de respuesta inválido de la API';

  @override
  String get generatingMockData => 'Generando datos de prueba...';

  @override
  String get mockDataGeneratedSuccessfully =>
      '¡Datos de prueba generados exitosamente!';

  @override
  String errorGeneratingMockData(String error) {
    return 'Error al generar datos de prueba: $error';
  }

  @override
  String get databaseDeletedSuccessfully =>
      'Base de datos eliminada exitosamente';

  @override
  String errorDeletingDatabase(String error) {
    return 'Error al eliminar base de datos: $error';
  }

  @override
  String get backupDeletedSuccessfully => 'Respaldo eliminado exitosamente';

  @override
  String failedToDeleteBackup(String error) {
    return 'Error al eliminar respaldo: $error';
  }

  @override
  String get pleaseEnterValidApiKey =>
      'Por favor ingresa una clave API válida primero';

  @override
  String get processing => 'Procesando...';

  @override
  String get startYourShoppingJourney => 'Comienza tu viaje de compras';

  @override
  String get searchForItemViewHistory =>
      'Busca un artículo para ver su historial de precios';

  @override
  String get orChooseFromPreviousItems =>
      'O elige de tus artículos anteriores:';

  @override
  String get searchResults => 'Resultados de Búsqueda:';

  @override
  String get addItemsToSeeHere =>
      'Agrega artículos a tus listas de compras para verlos aquí';

  @override
  String tryDifferentSearchOrCreate(String searchQuery) {
    return 'Intenta con un término de búsqueda diferente o crea un gráfico para \"$searchQuery\"';
  }

  @override
  String get areYouSureDeleteBackup =>
      '¿Estás seguro de que quieres eliminar este respaldo?';

  @override
  String get mockDataGenerationDescription =>
      'Esto creará listas de compras de ejemplo con artículos a lo largo del año para pruebas de análisis. Esto puede tomar algunos momentos.';

  @override
  String get databaseDeletionWarning =>
      'Esto eliminará permanentemente todos tus datos incluyendo listas de compras, artículos y configuraciones. Esta acción no se puede deshacer.';

  @override
  String get shoppingListsAlwaysIncluded =>
      'Listas de Compras (siempre incluidas)';

  @override
  String get chooseAdditionalData => 'Elige datos adicionales para incluir:';

  @override
  String get settings => 'Configuración';

  @override
  String get chatHistory => 'Historial de Chat';

  @override
  String get suggestions => 'Sugerencias';

  @override
  String addSearchQuery(String searchQuery) {
    return 'Agregar \"$searchQuery\"';
  }

  @override
  String viewChartFor(String searchQuery) {
    return 'Ver gráfico para \"$searchQuery\"';
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
      'Elige el modelo de IA para usar en el procesamiento';

  @override
  String get actionsDiscarded => 'Acciones Descartadas';

  @override
  String get weeklyOverview => 'Resumen Semanal';

  @override
  String get errorLoadingInsights => 'Error al cargar información';

  @override
  String get noMatchingItemsFound => 'No se encontraron artículos coincidentes';

  @override
  String get removeItemAndSuggestion => '¿Eliminar Artículo y Sugerencia?';

  @override
  String get removeSuggestion => '¿Eliminar Sugerencia?';

  @override
  String removeItemAndSuggestionDesc(String itemName) {
    return 'Esto eliminará \"$itemName\" de tu lista de compras actual y también de tus sugerencias.';
  }

  @override
  String removeSuggestionDesc(String itemName) {
    return 'Esto eliminará \"$itemName\" de tus sugerencias. No afectará tu lista de compras actual.';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String itemsSelected(int count) {
    return '$count seleccionados';
  }

  @override
  String chatWith(String listName) {
    return 'Chatear con $listName';
  }

  @override
  String get reviewAiSuggestions => 'Revisar Sugerencias de IA';

  @override
  String get pleaseSelectAtLeastOneAction =>
      'Por favor selecciona al menos una acción para ejecutar';

  @override
  String get appliedActions => 'Acciones Aplicadas';

  @override
  String get noActionsWereApplied => 'No se aplicaron acciones';

  @override
  String get frequentlyBoughtItems => 'Artículos Comprados Frecuentemente';

  @override
  String get searchItem => 'Buscar artículo';

  @override
  String get noFrequentlyBoughtItems =>
      'No hay artículos comprados frecuentemente';

  @override
  String get completeListsToSeeMostBought =>
      'Completa listas de compras para ver tus artículos más comprados';

  @override
  String timesPurchased(int count) {
    return 'Comprado $count veces';
  }

  @override
  String get errorLoadingFrequentlyBought =>
      'Error al cargar artículos comprados frecuentemente';

  @override
  String get errorLoadingData => 'Error al cargar datos';

  @override
  String get discoverShoppingPatterns => 'Descubre tus patrones de compra';

  @override
  String get errorLoadingPriceHistory => 'Error al cargar historial de precios';

  @override
  String get onlyOnePurchaseFound => 'Solo se encontró una compra';

  @override
  String lastPurchasedFor(String price) {
    return 'Última compra por $price';
  }

  @override
  String purchasedOn(String date) {
    return 'Comprado el $date';
  }

  @override
  String get purchaseMoreTimesToSeeTrends =>
      'Compra este artículo más veces para ver tendencias de precio';

  @override
  String get average => 'Promedio';

  @override
  String get lowest => 'Más Bajo';

  @override
  String get highest => 'Más Alto';

  @override
  String get searchOrAddNewItem => 'Buscar o agregar nuevo artículo...';

  @override
  String get frequentlyBought => 'Comprados Frecuentemente';

  @override
  String errorLoadingResults(String error) {
    return 'Error al cargar resultados: $error';
  }

  @override
  String get searchResultsZero => 'Resultados de Búsqueda (0)';

  @override
  String tryDifferentSearchOrAdd(String searchQuery) {
    return 'Intenta con un término de búsqueda diferente o agrega \"$searchQuery\" como un nuevo artículo';
  }

  @override
  String get errorLoadingItem => 'Error al cargar artículo';

  @override
  String get itemNotFound => 'Artículo no encontrado';

  @override
  String confirmDeleteItem(String itemName) {
    return '¿Estás seguro de que quieres eliminar \"$itemName\"?';
  }

  @override
  String get quantity => 'Cantidad';

  @override
  String get required => 'Requerido';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get price => 'Precio';

  @override
  String get total => 'Total';

  @override
  String get errorLoadingShopListItems =>
      'No se pudieron cargar los artículos de la lista de compras debido a un error.';

  @override
  String get noItemsInCartYet => 'Aún no hay artículos en el carrito';

  @override
  String get readyToStartShopping => '¿Listo para comenzar a comprar?';

  @override
  String get itemsYouCheckOffWillAppearHere =>
      'Los artículos que marques aparecerán aquí';

  @override
  String get tapPlusButtonToAddFirstItem =>
      'Presiona el botón + de abajo para agregar tu primer artículo';

  @override
  String get needMoreItems => '¿Necesitas más artículos?';

  @override
  String get tapButtonBelowToAddMoreItems =>
      'Presiona el botón de abajo para agregar más artículos';

  @override
  String get addItemsYouStillNeedToBuy =>
      'Agrega artículos que aún necesitas comprar';

  @override
  String get tapButtonBelowToAddFirstItem =>
      'Presiona el botón de abajo para agregar tu primer artículo';

  @override
  String get addFirstItemToGetStarted =>
      'Agrega tu primer artículo para comenzar';

  @override
  String get generate => 'Generar';

  @override
  String get ai => 'IA';

  @override
  String get filterModels => 'Filtrar Modelos';

  @override
  String get thinkingCapabilities => 'Capacidades de Pensamiento';

  @override
  String get inputTokensInMillions => 'Tokens de Entrada (en millones)';

  @override
  String get minValue => 'Valor Mínimo';

  @override
  String get maxValue => 'Valor Máximo';

  @override
  String get outputTokensInMillions => 'Tokens de Salida (en millones)';

  @override
  String get temperatureRange => 'Rango de Temperatura';

  @override
  String get retry => 'Reintentar';

  @override
  String get actionsApplied => 'Acciones Aplicadas';

  @override
  String get applyActions => 'Aplicar Acciones';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get pleaseGoBackToHomeScreen =>
      'Por favor regresa a la pantalla de inicio';

  @override
  String get priceTrendForLastPurchases =>
      'Tendencia de precio para las últimas compras';

  @override
  String get settingsWillNotBeIncluded => 'La configuración no será incluida';

  @override
  String get snapshotCreatedSuccessfully => 'Instantánea creada exitosamente';

  @override
  String get create => 'Crear';

  @override
  String get snapshotCreated => 'Instantánea Creada';

  @override
  String snapshotFailed(String error) {
    return 'Error en la instantánea: $error';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get manualSnapshots => 'Instantáneas Manuales';

  @override
  String get restoreBackup => 'Restaurar Respaldo';

  @override
  String get replaceExistingData => 'Reemplazar datos existentes';

  @override
  String get clearCurrentDataBeforeRestoring =>
      'Limpiar todos los datos actuales antes de restaurar';

  @override
  String restoreFailed(String error) {
    return 'Error en la restauración: $error';
  }

  @override
  String get chooseWhatToInclude => 'Elige qué incluir';

  @override
  String get fullExport => 'Exportación Completa';

  @override
  String get databaseOnly => 'Solo Base de Datos';

  @override
  String get createSnapshot => 'Crear Instantánea';

  @override
  String get done => 'Hecho';

  @override
  String get clearAllCurrentDataBeforeImporting =>
      'Limpiar todos los datos actuales antes de importar';

  @override
  String get restoreSuccessful => 'Restauración Exitosa';

  @override
  String filtersWithCount(int count) {
    return 'Filtros ($count)';
  }

  @override
  String get filter => 'Filtrar';

  @override
  String get clearAllFilters => 'Limpiar Todos los Filtros';

  @override
  String errorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get created => 'Creado';

  @override
  String get size => 'Tamaño';

  @override
  String get important => 'Importante';

  @override
  String get dataReplacementWarning =>
      'Esto eliminará permanentemente todos los datos actuales y los reemplazará con los datos del respaldo.';

  @override
  String get dataMergeWarning =>
      'Esto combinará los datos del respaldo con tus datos actuales. Pueden ocurrir duplicados.';

  @override
  String get dataRestoredSuccessfully => 'Datos restaurados exitosamente';

  @override
  String get backupDataMergedSuccessfully =>
      'Datos del respaldo combinados exitosamente';

  @override
  String get quickOptions => 'Opciones Rápidas';

  @override
  String get shoppingLists => 'Listas de Compras';

  @override
  String get backupInformation => 'Información del Respaldo';

  @override
  String get file => 'Archivo';

  @override
  String get includesSettings => 'Incluye Configuración';

  @override
  String get importOptions => 'Opciones de Importación';

  @override
  String get dataRestoredSuccessfullyMessage =>
      'Tus datos han sido restaurados exitosamente.';

  @override
  String get backupDataMergedSuccessfullyMessage =>
      'Los datos del respaldo han sido combinados con tus datos actuales exitosamente.';

  @override
  String get aiAssistantConfiguration => 'Configuración del Asistente de IA';

  @override
  String get configureAiAssistantDescription =>
      'Configura tu asistente de IA para ayudar a administrar listas de compras y proporcionar sugerencias.';

  @override
  String get apiConfiguration => 'Configuración de API';

  @override
  String get setupGeminiApiKeyDescription =>
      'Configura tu clave API de Google™ Gemini™ para habilitar funciones de IA';

  @override
  String get connectionStatus => 'Estado de Conexión';

  @override
  String get aboutGoogleGemini => 'Acerca de Google™ Gemini™';

  @override
  String get getFreeApiKeyFromGoogleAi =>
      'Obtén tu clave API gratuita desde Google™ AI Studio';

  @override
  String get aiFeaturesIncludeChatAndSuggestions =>
      'Las funciones de IA incluyen asistencia de chat y sugerencias inteligentes';

  @override
  String get apiKeyStoredSecurely =>
      'Tu clave API se almacena de forma segura en tu dispositivo';

  @override
  String get apiUsageSubjectToRateLimits =>
      'El uso de la API puede estar sujeto a los límites de velocidad de Google™';

  @override
  String get googleTrademarkDisclaimer =>
      'Google™ y Gemini™ son marcas comerciales de Google LLC. Esta aplicación no está afiliada con Google.';

  @override
  String get automaticBackup => 'Respaldo Automático';

  @override
  String get dataAutomaticallyBackedUpToDrive =>
      'Tus datos se respaldan automáticamente en Google Drive';

  @override
  String get automaticBackupEnabledAndWorking =>
      'El respaldo automático está habilitado y funcionando';

  @override
  String get automaticBackupConfigurationDetected =>
      'Configuración de respaldo automático detectada';

  @override
  String get automaticBackupInfoMessage =>
      'El respaldo automático se ejecuta periódicamente en segundo plano. Las instantáneas manuales funcionan localmente, pero no sobrevivirán a las desinstalaciones de la aplicación hasta que el respaldo automático las haya sincronizado con Google Drive.';

  @override
  String get howBackupWorks => 'Cómo Funciona el Respaldo';

  @override
  String get automaticBackupSyncsToGoogleDrive =>
      'El respaldo automático sincroniza tus datos con Google Drive';

  @override
  String get manualSnapshotsStoredLocallyAndSynced =>
      'Las instantáneas manuales se almacenan localmente e incluyen en la sincronización automática';

  @override
  String get restoringWillReplaceCurrentData =>
      'Restaurar reemplazará tus datos actuales';

  @override
  String get backupsIncludeShoppingListsChatAndSettings =>
      'Los respaldos incluyen listas de compras, historial de chat y opcionalmente configuración';

  @override
  String get noManualSnapshotsYet => 'Aún no hay instantáneas manuales';

  @override
  String get createManualSnapshotForAdditionalControl =>
      'Crea una instantánea manual para tener control adicional sobre tus datos';

  @override
  String get createAndManageAdditionalSnapshotFiles =>
      'Crear y administrar archivos de instantánea adicionales';

  @override
  String get thinking => 'Pensamiento';

  @override
  String get input => 'Entrada';

  @override
  String get output => 'Salida';

  @override
  String get temperature => 'Temperatura';

  @override
  String get tokensUnit => 'M tokens';

  @override
  String get filteredBy => 'Filtrado por';

  @override
  String get clear => 'Limpiar';

  @override
  String confirmDeleteShopList(String listName) {
    return '¿Estás seguro de que quieres eliminar la lista de compras \"$listName\"?';
  }

  @override
  String get noShoppingListsYet => 'Aún No Hay Listas de Compras';

  @override
  String get createFirstShoppingListDescription =>
      '¡Crea tu primera lista de compras arriba para comenzar a organizar tu mandado y nunca olvidar un artículo otra vez!';

  @override
  String get recentLists => 'Listas Recientes';

  @override
  String itemsShown(int count) {
    return '$count mostrados';
  }

  @override
  String itemsCompleted(int completed, int total) {
    return '$completed de $total artículos completados';
  }

  @override
  String get continueShopping => 'Continuar Comprando';

  @override
  String get viewList => 'Ver Lista';

  @override
  String itemsProgress(int completed, int total) {
    return '$completed de $total artículos';
  }

  @override
  String get remaining => 'Por Comprar';

  @override
  String get allItems => 'Todos los Artículos';

  @override
  String allItemsWithCount(int count) {
    return 'Todos los Artículos ($count)';
  }

  @override
  String get apiConnected => 'API Conectada';

  @override
  String get connected => 'Conectado';

  @override
  String connectedWithModels(int count) {
    return 'Conectado ($count modelos disponibles)';
  }

  @override
  String get verifyingApiKey => 'Verificando Clave API...';

  @override
  String get checkingConnectionGemini =>
      'Verificando conexión con la API de Gemini...';

  @override
  String get manageList => 'Administrar';
}
