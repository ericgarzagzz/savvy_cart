import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(
      await _getDatabasePath(),
      version: 7,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future<String> _getDatabasePath() async {
    return join(await getDatabasesPath(), 'savvy_cart_database.db');
  }

  Future purgeDatabase() async {
    return deleteDatabase(await _getDatabasePath());
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    var batch = db.batch();

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

    await batch.commit();
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

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

    await batch.commit();
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
        gemini_response_json TEXT,
        actions_executed INTEGER NOT NULL DEFAULT 0,
        executed_actions_json TEXT,
        is_error INTEGER NOT NULL DEFAULT 0
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

  Future<List<ShopList>> getShopLists() async {
    Database db = await instance.database;
    var shopLists = await db.query("shop_lists", orderBy: "id DESC");
    List<ShopList> shopListCollection = shopLists.isNotEmpty
      ? shopLists.map((x) => ShopList.fromMap(x)).toList()
      : [];
    return shopListCollection;
  }

  Future<ShopList?> getShopListById(int id) async {
    Database db = await instance.database;
    var shopListMap = await db.query('shop_lists', where: 'id = ?', whereArgs: [id]);
    if (shopListMap.isNotEmpty) {
      return ShopList.fromMap(shopListMap.first);
    }
    return null;
  }

  Future<int> addShopList(ShopList shopList) async {
    Database db = await instance.database;
    return await db.insert("shop_lists", shopList.toMap());
  }

  Future<List<ShopListItem>> getShopListItems(int shopListId) async {
    Database db = await instance.database;
    var shopListItems = await db.query("shop_list_items",
        where: 'shop_list_id = ?',
        whereArgs: [shopListId]
    );
    List<ShopListItem> shopListItemsCollection = shopListItems.isNotEmpty
        ? shopListItems.map((x) => ShopListItem.fromMap(x)).toList()
        : [];
    return shopListItemsCollection;
  }

  Future<List<ShopListItem>> getShopListItemsByStatus(int shopListId, bool checked) async {
    Database db = await instance.database;
    var shopListItems = await db.query("shop_list_items",
        where: 'shop_list_id = ? AND checked = ?',
        whereArgs: [shopListId, checked ? 1 : 0]
    );
    List<ShopListItem> shopListItemsCollection = shopListItems.isNotEmpty
        ? shopListItems.map((x) => ShopListItem.fromMap(x)).toList()
        : [];
    return shopListItemsCollection;
  }

  Future<Money> calculateShopListCheckedAmount(int shopListId) async {
    var shopListItems = await getShopListItems(shopListId);
    return shopListItems
        .where((x) => x.checked)
        .fold<Money>(Money(cents: 0), (prev, current) => prev + (current.unitPrice * current.quantity));
  }

  Future<(int checkedCount, int totalCount)> calculateShopListItemCounts(int shopListId) async {
    final shopListItems = await getShopListItems(shopListId);

    final int totalCount = shopListItems.length;
    final int checkedCount = shopListItems.where((item) => item.checked).length;

    return (checkedCount, totalCount);
  }

  Future<(Money uncheckedAmount, Money checkedAmount)> calculateShopListItemStats(int shopListId) async {
    final shopListItems = await getShopListItems(shopListId);

    Money uncheckedAmount = Money(cents: 0);
    Money checkedAmount = Money(cents: 0);

    for (final item in shopListItems) {
      if (item.checked) {
        checkedAmount += item.unitPrice * item.quantity;
      } else {
        uncheckedAmount += item.unitPrice * item.quantity;
      }
    }

    return (uncheckedAmount, checkedAmount);
  }

  Future<List<Suggestion>> getSuggestions() async {
    Database db = await instance.database;
    var suggestions = await db.query("suggestions", orderBy: "name ASC");
    List<Suggestion> collection = suggestions.isNotEmpty
      ? suggestions.map((x) => Suggestion.fromMap(x)).toList()
      : [];
    return collection;
  }

  Future<int> addSuggestion(String name) async {
    Database db = await instance.database;

    var existing = await db.query(
        'suggestions',
        where: 'LOWER(name) = ?',
        whereArgs: [name.toLowerCase()]
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    var suggestion = Suggestion(name: name.toLowerCase());

    return await db.insert("suggestions", suggestion.toMap());
  }

  Future<int> addShopListItem(ShopListItem shopListItem) async {
    Database db = await instance.database;
    return await db.insert("shop_list_items", shopListItem.toMap());
  }

  Future<int> setShopListItemChecked(int shopListItemId, bool checked) async {
    Database db = await instance.database;
    return await db.update(
      "shop_list_items",
      {"checked": checked ? 1 : 0},
      where: "id = ?",
      whereArgs: [shopListItemId],
    );
  }

  Future<int> updateShopListItem(ShopListItem shopListItem) async {
    Database db = await instance.database;
    return await db.update(
      "shop_list_items",
      shopListItem.toMap(),
      where: "id = ?",
      whereArgs: [shopListItem.id],
    );
  }

  Future<int> updateShopListItemByName(
      int shopListId,
      String name,
      {Decimal? quantity,
      Money? unitPrice,
      bool? checked}) async {
    final existingItem = await getShopListItemByName(shopListId, name);

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
        quantity: quantity ?? existingItem.quantity,
        unitPrice: unitPrice ?? existingItem.unitPrice,
        checked: checked ?? existingItem.checked,
      );
      return await updateShopListItem(updatedItem);
    } else {
      // If item doesn't exist, add it
      return await addShopListItem(
        ShopListItem(
          shopListId: shopListId,
          name: name,
          quantity: quantity ?? Decimal.one,
          unitPrice: unitPrice ?? Money(cents: 0),
          checked: checked ?? false,
        ),
      );
    }
  }

  Future<int> setShopListItemCheckedByName(int shopListId, String name, bool checked) async {
    Database db = await instance.database;
    return await db.update(
      "shop_list_items",
      {"checked": checked ? 1 : 0},
      where: "shop_list_id = ? AND LOWER(name) = LOWER(?)",
      whereArgs: [shopListId, name],
    );
  }

  Future<bool> shopListItemExists(int shopListId, String itemName) async {
    Database db = await instance.database;
    var existing = await db.query(
      'shop_list_items',
      where: 'shop_list_id = ? AND LOWER(name) = ?',
      whereArgs: [shopListId, itemName.toLowerCase()],
    );
    return existing.isNotEmpty;
  }
  
  Future<ShopListItem?> getShopListItemById(int id) async {
    Database db = await instance.database;
    var shopListItemMap = await db.query('shop_list_items', where: 'id = ?', whereArgs: [id]);
    if (shopListItemMap.isNotEmpty) {
      return ShopListItem.fromMap(shopListItemMap.first);
    }
    return null;
  }

  Future<int> removeShopList(int id) async {
    Database db = await instance.database;
    return db.delete("shop_lists", where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeShopListItem(int id) async {
    Database db = await instance.database;
    return await db.delete("shop_list_items", where: "id = ?", whereArgs: [id]);
  }

  Future<ShopListItem?> getShopListItemByName(int shopListId, String name) async {
    Database db = await instance.database;
    var shopListItemMap = await db.query(
      'shop_list_items',
      where: 'shop_list_id = ? AND LOWER(name) = LOWER(?)',
      whereArgs: [shopListId, name],
    );
    if (shopListItemMap.isNotEmpty) {
      return ShopListItem.fromMap(shopListItemMap.first);
    }
    return null;
  }

  Future<int> removeShopListItemByName(int shopListId, String name) async {
    Database db = await instance.database;
    return await db.delete(
      "shop_list_items",
      where: "shop_list_id = ? AND LOWER(name) = LOWER(?)",
      whereArgs: [shopListId, name],
    );
  }

  Future<int> removeSuggestionByName(String name) async {
    Database db = await instance.database;
    return await db.delete("suggestions", where: "LOWER(name) = LOWER(?)", whereArgs: [name]);
  }

  Future<List<ChatMessage>> getChatMessages(int shopListId) async {
    Database db = await instance.database;
    var chatMessages = await db.query(
      "chat_messages",
      where: 'shop_list_id = ?',
      whereArgs: [shopListId],
      orderBy: 'timestamp ASC'
    );
    List<ChatMessage> chatMessageCollection = chatMessages.isNotEmpty
        ? chatMessages.map((x) => ChatMessage.fromMap(x)).toList()
        : [];
    return chatMessageCollection;
  }

  Future<List<ChatMessage>> getChatMessagesByShopList(int shopListId) async {
    Database db = await instance.database;
    var chatMessages = await db.query(
      "chat_messages", 
      where: "shop_list_id = ?", 
      whereArgs: [shopListId],
      orderBy: "timestamp ASC"
    );
    List<ChatMessage> chatMessageCollection = chatMessages.isNotEmpty
        ? chatMessages.map((x) => ChatMessage.fromMap(x)).toList()
        : [];
    return chatMessageCollection;
  }

  Future<int> addChatMessage(ChatMessage chatMessage) async {
    Database db = await instance.database;
    return await db.insert("chat_messages", chatMessage.toMap());
  }

  Future<int> removeChatMessage(int id) async {
    Database db = await instance.database;
    return await db.delete("chat_messages", where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeChatMessagesByShopList(int shopListId) async {
    Database db = await instance.database;
    return await db.delete("chat_messages", where: "shop_list_id = ?", whereArgs: [shopListId]);
  }

  Future<int> markChatMessageActionsExecuted(int chatMessageId, String executedActionsJson) async {
    Database db = await instance.database;
    return await db.update(
      "chat_messages", 
      {
        "actions_executed": 1,
        "executed_actions_json": executedActionsJson
      }, 
      where: "id = ?", 
      whereArgs: [chatMessageId]
    );
  }

}