// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'SavvyCart';

  @override
  String get appSubtitle => 'Listas de Compras Inteligentes';

  @override
  String get settingsTitle => 'Configurações do SavvyCart';

  @override
  String chatWithList(String listName) {
    return 'Conversar com $listName';
  }

  @override
  String get searchItemPrice => 'Buscar Preço do Item';

  @override
  String get backupAndRestore => 'Backup e Restauração';

  @override
  String get shoppingInsights => 'Insights de Compras';

  @override
  String get searchLists => 'Buscar Listas';

  @override
  String get selectGeminiModel => 'Selecionar Modelo Gemini™';

  @override
  String get aiSettings => 'Configurações de IA';

  @override
  String get addItem => 'Adicionar Item';

  @override
  String get createShoppingList => 'Criar Lista de Compras';

  @override
  String get createNewList => 'Criar Nova Lista';

  @override
  String get loadMore => 'Carregar Mais';

  @override
  String get executeSelectedActions => 'Executar Ações Selecionadas';

  @override
  String get clearAll => 'Limpar Tudo';

  @override
  String get apply => 'Aplicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Fechar';

  @override
  String get goHome => 'Ir ao Início';

  @override
  String get goToHomePage => 'Ir para a Página Inicial';

  @override
  String get enterListName => 'Digite o nome da lista';

  @override
  String get listName => 'Nome da Lista';

  @override
  String get itemName => 'Nome do Item';

  @override
  String get enterItemName => 'Digite o nome do item...';

  @override
  String get searchByListName => 'Buscar por nome da lista...';

  @override
  String get typeYourMessage => 'Digite sua mensagem...';

  @override
  String get geminiApiKey => 'Chave API do Google™ Gemini™';

  @override
  String get geminiModel => 'Modelo Gemini™';

  @override
  String get listNameCannotBeEmpty => 'O nome da lista não pode estar vazio';

  @override
  String get aiAssistant => 'Assistente de IA';

  @override
  String get data => 'Dados';

  @override
  String get localization => 'Localização';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get systemLanguage => 'Idioma do Sistema';

  @override
  String get autoDetectFromDeviceSettings =>
      'Detectar automaticamente das configurações do dispositivo';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get generateMockData => 'Gerar Dados de Teste';

  @override
  String get deleteDatabase => 'Excluir Banco de Dados';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get ready => 'Pronto';

  @override
  String get notVerified => 'Não verificado';

  @override
  String get notConfigured => 'Não configurado';

  @override
  String get manageBackups => 'Gerenciar backups';

  @override
  String get addSampleShoppingLists => 'Adicionar listas de compras de exemplo';

  @override
  String get clearAllData => 'Limpar todos os dados';

  @override
  String get loading => 'Carregando...';

  @override
  String get recommended => 'Recomendado';

  @override
  String get deleteShopList => 'Excluir lista de compras';

  @override
  String get editItemName => 'Editar Nome do Item';

  @override
  String get deleteItem => 'Excluir Item';

  @override
  String get deleteBackup => 'Excluir Backup';

  @override
  String get createManualSnapshot => 'Criar Snapshot Manual';

  @override
  String get error => 'Erro';

  @override
  String get toBuy => 'Para Comprar';

  @override
  String get inCart => 'No Carrinho';

  @override
  String get listsCreated => 'Listas Criadas';

  @override
  String get totalSpent => 'Total Gasto';

  @override
  String get filterByDateRange => 'Filtrar por Período';

  @override
  String get startDate => 'Data de Início';

  @override
  String get endDate => 'Data Final';

  @override
  String get tokenLimits => 'Limites de Tokens';

  @override
  String get all => 'Todos';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String searchResultsCount(int count) {
    return 'Resultados da Busca ($count)';
  }

  @override
  String get noShoppingDataYet => 'Ainda Não Há Dados de Compras';

  @override
  String get createFirstListDescription =>
      'Crie sua primeira lista de compras para começar a acompanhar insights sobre seus padrões de compra e hábitos de gastos.';

  @override
  String get noItemsFound => 'Nenhum item encontrado';

  @override
  String tryDifferentSearchTerm(String searchQuery) {
    return 'Tente um termo de busca diferente ou adicione \"$searchQuery\" como um novo item';
  }

  @override
  String get noPriceHistoryAvailable => 'Nenhum histórico de preços disponível';

  @override
  String get purchaseItemToTrackPrice =>
      'Compre este item para começar a acompanhar suas tendências de preço';

  @override
  String get noListsFound => 'Nenhuma lista encontrada';

  @override
  String get tryAdjustingFilters =>
      'Tente ajustar seus termos de busca ou filtros de data';

  @override
  String get loadingAvailableModels => 'Carregando modelos disponíveis...';

  @override
  String failedToRemoveItem(String error) {
    return 'Falha ao remover item: $error';
  }

  @override
  String get couldNotLoadShopListItems =>
      'Não foi possível carregar os itens da lista de compras devido a um erro.';

  @override
  String get errorLoadingSearchResults =>
      'Erro ao carregar resultados da busca';

  @override
  String get pleaseTryAgainLater => 'Por favor, tente novamente mais tarde';

  @override
  String get errorLoadingSuggestions => 'Erro ao carregar sugestões';

  @override
  String failedToLoadBackupInfo(String error) {
    return 'Falha ao carregar informações do backup: $error';
  }

  @override
  String pageNotFound(String uri) {
    return 'Página não encontrada: $uri';
  }

  @override
  String get invalidShopListId => 'ID da lista de compras inválido';

  @override
  String get invalidItemName => 'Nome do item inválido';

  @override
  String badRequest(String responseBody) {
    return 'Solicitação incorreta: $responseBody';
  }

  @override
  String get invalidApiKeyOrAuth =>
      'Chave API inválida ou falha na autenticação';

  @override
  String get accessForbidden =>
      'Acesso negado - verifique as permissões da API';

  @override
  String get apiRateLimitExceeded =>
      'Limite de taxa da API excedido. Por favor, tente novamente mais tarde.';

  @override
  String get internalServerError => 'Erro interno do servidor';

  @override
  String get badGateway =>
      'Gateway incorreto - serviço temporariamente indisponível';

  @override
  String get serviceUnavailable => 'Serviço indisponível';

  @override
  String get gatewayTimeout => 'Tempo limite do gateway esgotado';

  @override
  String get noInternetConnection =>
      'Nenhuma conexão com a internet disponível';

  @override
  String get requestTimedOut => 'Tempo limite da solicitação esgotado';

  @override
  String get invalidResponseFormat => 'Formato de resposta inválido da API';

  @override
  String get generatingMockData => 'Gerando dados de teste...';

  @override
  String get mockDataGeneratedSuccessfully =>
      'Dados de teste gerados com sucesso!';

  @override
  String errorGeneratingMockData(String error) {
    return 'Erro ao gerar dados de teste: $error';
  }

  @override
  String get databaseDeletedSuccessfully =>
      'Banco de dados excluído com sucesso';

  @override
  String errorDeletingDatabase(String error) {
    return 'Erro ao excluir banco de dados: $error';
  }

  @override
  String get backupDeletedSuccessfully => 'Backup excluído com sucesso';

  @override
  String failedToDeleteBackup(String error) {
    return 'Falha ao excluir backup: $error';
  }

  @override
  String get pleaseEnterValidApiKey =>
      'Por favor, digite uma chave API válida primeiro';

  @override
  String get processing => 'Processando...';

  @override
  String get startYourShoppingJourney => 'Inicie sua jornada de compras';

  @override
  String get searchForItemViewHistory =>
      'Busque um item para ver seu histórico de preços';

  @override
  String get orChooseFromPreviousItems =>
      'Ou escolha de seus itens anteriores:';

  @override
  String get searchResults => 'Resultados da Busca:';

  @override
  String get addItemsToSeeHere =>
      'Adicione itens às suas listas de compras para vê-los aqui';

  @override
  String tryDifferentSearchOrCreate(String searchQuery) {
    return 'Tente um termo de busca diferente ou crie um gráfico para \"$searchQuery\"';
  }

  @override
  String get areYouSureDeleteBackup =>
      'Tem certeza de que deseja excluir este backup?';

  @override
  String get mockDataGenerationDescription =>
      'Isso criará listas de compras de exemplo com itens ao longo do ano para testes de análise. Isso pode levar alguns momentos.';

  @override
  String get databaseDeletionWarning =>
      'Isso excluirá permanentemente todos os seus dados incluindo listas de compras, itens e configurações. Esta ação não pode ser desfeita.';

  @override
  String get shoppingListsAlwaysIncluded =>
      'Listas de Compras (sempre incluídas)';

  @override
  String get chooseAdditionalData => 'Escolha dados adicionais para incluir:';

  @override
  String get settings => 'Configurações';

  @override
  String get chatHistory => 'Histórico de Chat';

  @override
  String get suggestions => 'Sugestões';

  @override
  String addSearchQuery(String searchQuery) {
    return 'Adicionar \"$searchQuery\"';
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
      'Escolha o modelo de IA para usar no processamento';

  @override
  String get actionsDiscarded => 'Ações Descartadas';

  @override
  String get weeklyOverview => 'Resumo Semanal';

  @override
  String get errorLoadingInsights => 'Erro ao carregar insights';

  @override
  String get noMatchingItemsFound => 'Nenhum item correspondente encontrado';

  @override
  String get removeItemAndSuggestion => 'Remover Item e Sugestão?';

  @override
  String get removeSuggestion => 'Remover Sugestão?';

  @override
  String removeItemAndSuggestionDesc(String itemName) {
    return 'Isso removerá \"$itemName\" da sua lista de compras atual e também das suas sugestões.';
  }

  @override
  String removeSuggestionDesc(String itemName) {
    return 'Isso removerá \"$itemName\" das suas sugestões. Não afetará sua lista de compras atual.';
  }

  @override
  String get remove => 'Remover';

  @override
  String itemsSelected(int count) {
    return '$count selecionados';
  }

  @override
  String chatWith(String listName) {
    return 'Conversar com $listName';
  }

  @override
  String get reviewAiSuggestions => 'Revisar Sugestões de IA';

  @override
  String get pleaseSelectAtLeastOneAction =>
      'Por favor, selecione pelo menos uma ação para executar';

  @override
  String get appliedActions => 'Ações Aplicadas';

  @override
  String get noActionsWereApplied => 'Nenhuma ação foi aplicada';

  @override
  String get frequentlyBoughtItems => 'Itens Comprados Frequentemente';

  @override
  String get searchItem => 'Buscar item';

  @override
  String get noFrequentlyBoughtItems => 'Nenhum item comprado frequentemente';

  @override
  String get completeListsToSeeMostBought =>
      'Complete listas de compras para ver seus itens mais comprados';

  @override
  String timesPurchased(int count) {
    return 'Comprado $count vezes';
  }

  @override
  String get errorLoadingFrequentlyBought =>
      'Erro ao carregar itens comprados frequentemente';

  @override
  String get errorLoadingData => 'Erro ao carregar dados';

  @override
  String get discoverShoppingPatterns => 'Descubra seus padrões de compra';

  @override
  String get errorLoadingPriceHistory => 'Erro ao carregar histórico de preços';

  @override
  String get onlyOnePurchaseFound => 'Apenas uma compra encontrada';

  @override
  String lastPurchasedFor(String price) {
    return 'Última compra por $price';
  }

  @override
  String purchasedOn(String date) {
    return 'Comprado em $date';
  }

  @override
  String get purchaseMoreTimesToSeeTrends =>
      'Compre este item mais vezes para ver tendências de preço';

  @override
  String get average => 'Média';

  @override
  String get lowest => 'Mais Baixo';

  @override
  String get highest => 'Mais Alto';

  @override
  String get searchOrAddNewItem => 'Buscar ou adicionar novo item...';

  @override
  String get frequentlyBought => 'Comprados Frequentemente';

  @override
  String errorLoadingResults(String error) {
    return 'Erro ao carregar resultados: $error';
  }

  @override
  String get searchResultsZero => 'Resultados da Busca (0)';

  @override
  String tryDifferentSearchOrAdd(String searchQuery) {
    return 'Tente um termo de busca diferente ou adicione \"$searchQuery\" como um novo item';
  }

  @override
  String get errorLoadingItem => 'Erro ao carregar item';

  @override
  String get itemNotFound => 'Item não encontrado';

  @override
  String confirmDeleteItem(String itemName) {
    return 'Tem certeza de que deseja excluir \"$itemName\"?';
  }

  @override
  String get quantity => 'Quantidade';

  @override
  String get required => 'Obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get price => 'Preço';

  @override
  String get total => 'Total';

  @override
  String get errorLoadingShopListItems =>
      'Não foi possível carregar os itens da lista de compras devido a um erro.';

  @override
  String get noItemsInCartYet => 'Ainda não há itens no carrinho';

  @override
  String get readyToStartShopping => 'Pronto para começar a comprar?';

  @override
  String get itemsYouCheckOffWillAppearHere =>
      'Os itens que você marcar aparecerão aqui';

  @override
  String get tapPlusButtonToAddFirstItem =>
      'Toque no botão + abaixo para adicionar seu primeiro item';

  @override
  String get needMoreItems => 'Precisa de mais itens?';

  @override
  String get tapButtonBelowToAddMoreItems =>
      'Toque no botão abaixo para adicionar mais itens';

  @override
  String get addItemsYouStillNeedToBuy =>
      'Adicione itens que você ainda precisa comprar';

  @override
  String get tapButtonBelowToAddFirstItem =>
      'Toque no botão abaixo para adicionar seu primeiro item';

  @override
  String get addFirstItemToGetStarted =>
      'Adicione seu primeiro item para começar';

  @override
  String get generate => 'Gerar';

  @override
  String get ai => 'IA';

  @override
  String get filterModels => 'Filtrar Modelos';

  @override
  String get thinkingCapabilities => 'Capacidades de Raciocínio';

  @override
  String get inputTokensInMillions => 'Tokens de Entrada (em milhões)';

  @override
  String get minValue => 'Valor Mínimo';

  @override
  String get maxValue => 'Valor Máximo';

  @override
  String get outputTokensInMillions => 'Tokens de Saída (em milhões)';

  @override
  String get temperatureRange => 'Faixa de Temperatura';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get actionsApplied => 'Ações Aplicadas';

  @override
  String get applyActions => 'Aplicar Ações';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get pleaseGoBackToHomeScreen => 'Por favor, volte para a tela inicial';

  @override
  String get priceTrendForLastPurchases =>
      'Tendência de preço para as últimas compras';

  @override
  String get settingsWillNotBeIncluded =>
      'As configurações não serão incluídas';

  @override
  String get snapshotCreatedSuccessfully => 'Snapshot criado com sucesso';

  @override
  String get create => 'Criar';

  @override
  String get snapshotCreated => 'Snapshot Criado';

  @override
  String snapshotFailed(String error) {
    return 'Falha no snapshot: $error';
  }

  @override
  String get restore => 'Restaurar';

  @override
  String get manualSnapshots => 'Snapshots Manuais';

  @override
  String get restoreBackup => 'Restaurar Backup';

  @override
  String get replaceExistingData => 'Substituir dados existentes';

  @override
  String get clearCurrentDataBeforeRestoring =>
      'Limpar todos os dados atuais antes de restaurar';

  @override
  String restoreFailed(String error) {
    return 'Falha na restauração: $error';
  }

  @override
  String get chooseWhatToInclude => 'Escolha o que incluir';

  @override
  String get fullExport => 'Exportação Completa';

  @override
  String get databaseOnly => 'Apenas Banco de Dados';

  @override
  String get createSnapshot => 'Criar Snapshot';

  @override
  String get done => 'Concluído';

  @override
  String get clearAllCurrentDataBeforeImporting =>
      'Limpar todos os dados atuais antes de importar';

  @override
  String get restoreSuccessful => 'Restauração Bem-sucedida';

  @override
  String filtersWithCount(int count) {
    return 'Filtros ($count)';
  }

  @override
  String get filter => 'Filtrar';

  @override
  String get clearAllFilters => 'Limpar Todos os Filtros';

  @override
  String errorWithDetails(String details) {
    return 'Erro: $details';
  }

  @override
  String get created => 'Criado';

  @override
  String get size => 'Tamanho';

  @override
  String get important => 'Importante';

  @override
  String get dataReplacementWarning =>
      'Isso excluirá permanentemente todos os dados atuais e os substituirá pelos dados do backup.';

  @override
  String get dataMergeWarning =>
      'Isso combinará os dados do backup com seus dados atuais. Podem ocorrer duplicatas.';

  @override
  String get dataRestoredSuccessfully => 'Dados restaurados com sucesso';

  @override
  String get backupDataMergedSuccessfully =>
      'Dados do backup combinados com sucesso';

  @override
  String get quickOptions => 'Opções Rápidas';

  @override
  String get shoppingLists => 'Listas de Compras';

  @override
  String get backupInformation => 'Informações do Backup';

  @override
  String get file => 'Arquivo';

  @override
  String get includesSettings => 'Inclui Configurações';

  @override
  String get importOptions => 'Opções de Importação';

  @override
  String get dataRestoredSuccessfullyMessage =>
      'Seus dados foram restaurados com sucesso.';

  @override
  String get backupDataMergedSuccessfullyMessage =>
      'Os dados do backup foram combinados com seus dados atuais com sucesso.';

  @override
  String get aiAssistantConfiguration => 'Configuração do Assistente de IA';

  @override
  String get configureAiAssistantDescription =>
      'Configure seu assistente de IA para ajudar a gerenciar listas de compras e fornecer sugestões.';

  @override
  String get apiConfiguration => 'Configuração da API';

  @override
  String get setupGeminiApiKeyDescription =>
      'Configure sua chave API do Google™ Gemini™ para habilitar recursos de IA';

  @override
  String get connectionStatus => 'Status da Conexão';

  @override
  String get aboutGoogleGemini => 'Sobre o Google™ Gemini™';

  @override
  String get getFreeApiKeyFromGoogleAi =>
      'Obtenha sua chave API gratuita no Google™ AI Studio';

  @override
  String get aiFeaturesIncludeChatAndSuggestions =>
      'Os recursos de IA incluem assistência de chat e sugestões inteligentes';

  @override
  String get apiKeyStoredSecurely =>
      'Sua chave API é armazenada com segurança em seu dispositivo';

  @override
  String get apiUsageSubjectToRateLimits =>
      'O uso da API pode estar sujeito aos limites de taxa do Google™';

  @override
  String get googleTrademarkDisclaimer =>
      'Google™ e Gemini™ são marcas registradas da Google LLC. Este aplicativo não é afiliado ao Google.';

  @override
  String get automaticBackup => 'Backup Automático';

  @override
  String get dataAutomaticallyBackedUpToDrive =>
      'Seus dados são automaticamente salvos no Google Drive';

  @override
  String get automaticBackupEnabledAndWorking =>
      'O backup automático está habilitado e funcionando';

  @override
  String get automaticBackupConfigurationDetected =>
      'Configuração de backup automático detectada';

  @override
  String get automaticBackupInfoMessage =>
      'O backup automático é executado periodicamente em segundo plano. Os snapshots manuais funcionam localmente, mas não sobreviverão às desinstalações do aplicativo até que o backup automático os tenha sincronizado com o Google Drive.';

  @override
  String get howBackupWorks => 'Como Funciona o Backup';

  @override
  String get automaticBackupSyncsToGoogleDrive =>
      'O backup automático sincroniza seus dados com o Google Drive';

  @override
  String get manualSnapshotsStoredLocallyAndSynced =>
      'Os snapshots manuais são armazenados localmente e incluídos na sincronização automática';

  @override
  String get restoringWillReplaceCurrentData =>
      'Restaurar substituirá seus dados atuais';

  @override
  String get backupsIncludeShoppingListsChatAndSettings =>
      'Os backups incluem listas de compras, histórico de chat e opcionalmente configurações';

  @override
  String get noManualSnapshotsYet => 'Ainda não há snapshots manuais';

  @override
  String get createManualSnapshotForAdditionalControl =>
      'Crie um snapshot manual para ter controle adicional sobre seus dados';

  @override
  String get createAndManageAdditionalSnapshotFiles =>
      'Criar e gerenciar arquivos de snapshot adicionais';

  @override
  String get thinking => 'Raciocínio';

  @override
  String get input => 'Entrada';

  @override
  String get output => 'Saída';

  @override
  String get temperature => 'Temperatura';

  @override
  String get tokensUnit => 'M tokens';

  @override
  String get filteredBy => 'Filtrado por';

  @override
  String get clear => 'Limpar';

  @override
  String confirmDeleteShopList(String listName) {
    return 'Tem certeza de que deseja excluir a lista de compras \"$listName\"?';
  }

  @override
  String get noShoppingListsYet => 'Ainda Não Há Listas de Compras';

  @override
  String get createFirstShoppingListDescription =>
      'Crie sua primeira lista de compras acima para começar a organizar suas compras e nunca mais esquecer um item!';

  @override
  String get recentLists => 'Listas Recentes';

  @override
  String itemsShown(int count) {
    return '$count mostrados';
  }

  @override
  String itemsCompleted(int completed, int total) {
    return '$completed de $total itens concluídos';
  }

  @override
  String get continueShopping => 'Continuar Comprando';

  @override
  String get viewList => 'Ver Lista';

  @override
  String itemsProgress(int completed, int total) {
    return '$completed de $total itens';
  }

  @override
  String get remaining => 'Para Comprar';

  @override
  String get allItems => 'Todos os Itens';

  @override
  String allItemsWithCount(int count) {
    return 'Todos os Itens ($count)';
  }

  @override
  String get apiConnected => 'API Conectada';

  @override
  String get connected => 'Conectado';

  @override
  String connectedWithModels(int count) {
    return 'Conectado ($count modelos disponíveis)';
  }

  @override
  String get verifyingApiKey => 'Verificando Chave API...';

  @override
  String get checkingConnectionGemini =>
      'Verificando conexão com a API do Gemini...';

  @override
  String get manageList => 'Gerenciar';
}
