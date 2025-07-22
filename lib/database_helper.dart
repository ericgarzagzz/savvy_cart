import 'dart:async';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  final DataManager _dataManager = DataManager.instance;

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    try {
      return await openDatabase(
        await _getDatabasePath(),
        version: 8,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } on DatabaseException catch (e) {
      throw DatabaseInitializationException(
        'Failed to initialize database: $e',
        e,
      );
    } on FileSystemException catch (e) {
      throw DatabaseInitializationException(
        'Database file system error: ${e.message}',
        e,
      );
    } catch (e) {
      throw DatabaseInitializationException(
        'Unexpected database initialization error: $e',
        e,
      );
    }
  }

  Future<String> _getDatabasePath() async {
    try {
      final path = await getDatabasesPath();
      return join(path, 'savvy_cart_database.db');
    } on FileSystemException catch (e) {
      throw DatabasePathException(
        'Cannot access database directory: ${e.message}',
        e,
      );
    } catch (e) {
      throw DatabasePathException(
        'Unexpected error getting database path: $e',
        e,
      );
    }
  }

  Future purgeDatabase() async {
    return _dataManager.purgeDatabase();
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    var batch = db.batch();

    try {
      _createTableShopListsV1(batch);
      _createTableShopListItemsV1(batch);
      _createTableSuggestionsV1(batch);

      if (version >= 2) {
        _createTableChatMessagesV2(batch);
      }

      if (version >= 3) {
        _updateChatMessagesV3(batch);
      }

      if (version >= 4) {
        _updateChatMessagesV4(batch);
      }

      if (version >= 5) {
        _updateChatMessagesV5(batch);
      }

      if (version >= 6) {
        _updateChatMessagesV6(batch);
      }

      if (version >= 7) {
        _updateChatMessagesV7(batch);
      }

      if (version >= 8) {
        _updateTablesV8(batch);
      }

      await batch.commit(noResult: false);
    } on DatabaseException catch (e) {
      throw DatabaseSchemaException('Failed to create database schema: $e', e);
    } catch (e) {
      throw DatabaseSchemaException(
        'Unexpected error during database creation: $e',
        e,
      );
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

    try {
      if (oldVersion < 2) {
        _createTableChatMessagesV2(batch);
      }

      if (oldVersion < 3) {
        _updateChatMessagesV3(batch);
      }

      if (oldVersion < 4) {
        _updateChatMessagesV4(batch);
      }

      if (oldVersion < 5) {
        _updateChatMessagesV5(batch);
      }

      if (oldVersion < 6) {
        _updateChatMessagesV6(batch);
      }

      if (oldVersion < 7) {
        _updateChatMessagesV7(batch);
      }

      if (oldVersion < 8) {
        _updateTablesV8(batch);
      }

      await batch.commit(noResult: false);
    } on DatabaseException catch (e) {
      throw DatabaseSchemaException(
        'Failed to upgrade database from version $oldVersion to $newVersion: $e',
        e,
      );
    } catch (e) {
      throw DatabaseSchemaException(
        'Unexpected error during database upgrade: $e',
        e,
      );
    }
  }

  void _createTableShopListsV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS shop_lists');
    batch.execute('''
      CREATE TABLE shop_lists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  void _createTableShopListItemsV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS shop_list_items');
    batch.execute('''
      CREATE TABLE shop_list_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shop_list_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit_price INTEGER NOT NULL,
        checked INTEGER NOT NULL
      )
    ''');
  }

  void _createTableSuggestionsV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS suggestions');
    batch.execute('''
      CREATE TABLE suggestions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  void _createTableChatMessagesV2(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS chat_messages');
    batch.execute('''
      CREATE TABLE chat_messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shop_list_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        gemini_response_json TEXT
      )
    ''');
  }

  void _updateChatMessagesV3(Batch batch) {
    batch.execute('''
      ALTER TABLE chat_messages 
      ADD COLUMN actions_executed INTEGER NOT NULL DEFAULT 0
    ''');
  }

  void _updateChatMessagesV4(Batch batch) {
    batch.execute('''
      ALTER TABLE chat_messages 
      ADD COLUMN executed_actions_json TEXT
    ''');
  }

  void _updateChatMessagesV5(Batch batch) {
    batch.execute('''
      ALTER TABLE chat_messages 
      ADD COLUMN is_error INTEGER NOT NULL DEFAULT 0
    ''');
  }

  void _updateChatMessagesV6(Batch batch) {
    batch.execute('''
      ALTER TABLE chat_messages 
      ADD COLUMN actions_discarded INTEGER NOT NULL DEFAULT 0
    ''');
  }

  void _updateChatMessagesV7(Batch batch) {
    // Remove the actions_discarded column by recreating the table
    batch.execute('''
      CREATE TABLE chat_messages_temp(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shop_list_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        gemini_response_json TEXT,
        actions_executed INTEGER NOT NULL DEFAULT 0,
        executed_actions_json TEXT,
        is_error INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(shop_list_id) REFERENCES shop_lists(id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      INSERT INTO chat_messages_temp 
      SELECT id, shop_list_id, text, is_user, timestamp, gemini_response_json, 
             actions_executed, executed_actions_json, is_error 
      FROM chat_messages
    ''');

    batch.execute('DROP TABLE chat_messages');
    batch.execute('ALTER TABLE chat_messages_temp RENAME TO chat_messages');
  }

  void _updateTablesV8(Batch batch) {
    batch.execute('''
      ALTER TABLE shop_lists 
      ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0
    ''');

    batch.execute('''
      ALTER TABLE shop_lists 
      ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0
    ''');

    batch.execute('''
      ALTER TABLE shop_list_items 
      ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0
    ''');

    batch.execute('''
      ALTER TABLE shop_list_items 
      ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0
    ''');

    batch.execute('''
      ALTER TABLE shop_list_items 
      ADD COLUMN checked_at INTEGER
    ''');

    batch.execute('''
      ALTER TABLE suggestions 
      ADD COLUMN created_at INTEGER NOT NULL DEFAULT 0
    ''');

    batch.execute('''
      ALTER TABLE suggestions 
      ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0
    ''');
  }

  Future<List<ShopList>> getShopLists() async {
    return _dataManager.shopLists.getAll();
  }

  Future<List<ShopList>> getShopListsPaginated({
    int limit = 3,
    int offset = 0,
  }) async {
    return _dataManager.shopLists.getPaginated(limit: limit, offset: offset);
  }

  Future<int> getShopListsCount() async {
    return _dataManager.shopLists.getCount();
  }

  Future<List<ShopList>> searchShopLists({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    return _dataManager.shopLists.search(
      query: query,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
  }

  Future<ShopList?> getShopListById(int id) async {
    return _dataManager.shopLists.getById(id);
  }

  Future<int> addShopList(ShopList shopList) async {
    return _dataManager.shopLists.add(shopList);
  }

  Future<List<ShopListItem>> getShopListItems(int shopListId) async {
    return _dataManager.shopListItems.getByShopListId(shopListId);
  }

  Future<List<ShopListItem>> getShopListItemsByStatus(
    int shopListId,
    bool checked,
  ) async {
    return _dataManager.shopListItems.getByShopListIdAndStatus(
      shopListId,
      checked,
    );
  }

  Future<Money> calculateShopListCheckedAmount(int shopListId) async {
    return _dataManager.shopListItems.calculateCheckedAmount(shopListId);
  }

  Future<(int checkedCount, int totalCount)> calculateShopListItemCounts(
    int shopListId,
  ) async {
    return _dataManager.shopListItems.calculateItemCounts(shopListId);
  }

  Future<(Money uncheckedAmount, Money checkedAmount)>
  calculateShopListItemStats(int shopListId) async {
    return _dataManager.shopListItems.calculateItemStats(shopListId);
  }

  Future<List<Suggestion>> getSuggestions() async {
    return _dataManager.suggestions.getAll();
  }

  Future<int> addSuggestion(String name) async {
    return _dataManager.suggestions.add(name);
  }

  Future<int> addShopListItem(ShopListItem shopListItem) async {
    return _dataManager.shopListItems.add(shopListItem);
  }

  Future<int> setShopListItemChecked(int shopListItemId, bool checked) async {
    return _dataManager.shopListItems.setChecked(shopListItemId, checked);
  }

  Future<int> updateShopListItem(ShopListItem shopListItem) async {
    return _dataManager.shopListItems.update(shopListItem);
  }

  Future<int> updateShopListItemByName(
    int shopListId,
    String name, {
    Decimal? quantity,
    Money? unitPrice,
    bool? checked,
  }) async {
    return _dataManager.shopListItems.updateByName(
      shopListId,
      name,
      quantity: quantity,
      unitPrice: unitPrice,
      checked: checked,
    );
  }

  Future<int> setShopListItemCheckedByName(
    int shopListId,
    String name,
    bool checked,
  ) async {
    return _dataManager.shopListItems.setCheckedByName(
      shopListId,
      name,
      checked,
    );
  }

  Future<bool> shopListItemExists(int shopListId, String itemName) async {
    return _dataManager.shopListItems.exists(shopListId, itemName);
  }

  Future<ShopListItem?> getShopListItemById(int id) async {
    return _dataManager.shopListItems.getById(id);
  }

  Future<int> removeShopList(int id) async {
    return _dataManager.shopLists.remove(id);
  }

  Future<int> removeShopListItem(int id) async {
    return _dataManager.shopListItems.remove(id);
  }

  Future<ShopListItem?> getShopListItemByName(
    int shopListId,
    String name,
  ) async {
    return _dataManager.shopListItems.getByName(shopListId, name);
  }

  Future<int> removeShopListItemByName(int shopListId, String name) async {
    return _dataManager.shopListItems.removeByName(shopListId, name);
  }

  Future<int> removeSuggestionByName(String name) async {
    return _dataManager.suggestions.removeByName(name);
  }

  Future<List<ChatMessage>> getChatMessages(int shopListId) async {
    return _dataManager.chatMessages.getByShopListId(shopListId);
  }

  Future<List<ChatMessage>> getChatMessagesByShopList(int shopListId) async {
    return _dataManager.chatMessages.getByShopListId(shopListId);
  }

  Future<int> addChatMessage(ChatMessage chatMessage) async {
    return _dataManager.chatMessages.add(chatMessage);
  }

  Future<int> removeChatMessage(int id) async {
    return _dataManager.chatMessages.remove(id);
  }

  Future<int> removeChatMessagesByShopList(int shopListId) async {
    return _dataManager.chatMessages.removeByShopListId(shopListId);
  }

  Future<int> markChatMessageActionsExecuted(
    int chatMessageId,
    String executedActionsJson,
  ) async {
    return _dataManager.chatMessages.markActionsExecuted(
      chatMessageId,
      executedActionsJson,
    );
  }

  Future<List<Map<String, dynamic>>> getFrequentlyBoughtItemsWithStatus({
    int limit = 5,
    required int shopListId,
  }) async {
    return _dataManager.analytics.getFrequentlyBoughtItemsWithStatus(
      limit: limit,
      shopListId: shopListId,
    );
  }

  Future<Money?> getLastRecordedPrice(String itemName) async {
    return _dataManager.shopListItems.getLastRecordedPrice(itemName);
  }

  Future<void> generateMockData() async {
    return _dataManager.mockData.generateMockData();
  }

  Future<int> getShopListsCountLastWeek() async {
    return _dataManager.shopLists.getCountLastWeek();
  }

  Future<Money> getTotalAmountLastWeek() async {
    return _dataManager.analytics.getTotalAmountLastWeek();
  }

  Future<List<FrequentlyBoughtItem>> getFrequentlyBoughtItemsLastMonth({
    int limit = 5,
  }) async {
    return _dataManager.analytics.getFrequentlyBoughtItemsLastMonth(
      limit: limit,
    );
  }

  Future<List<PriceHistoryEntry>> getItemPriceHistory(
    String itemName, {
    int limit = 5,
  }) async {
    return _dataManager.analytics.getItemPriceHistory(itemName, limit: limit);
  }
}
