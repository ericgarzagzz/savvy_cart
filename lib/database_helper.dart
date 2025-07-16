import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:faker/faker.dart';
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
      version: 8,
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
    
    if (version >= 8) {
      _updateTablesV8(batch);
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

    if (oldVersion < 8) {
      _updateTablesV8(batch);
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
    final now = DateTime.now().millisecondsSinceEpoch;
    final shopListMap = shopList.toMap();
    shopListMap['created_at'] = now;
    shopListMap['updated_at'] = now;
    return await db.insert("shop_lists", shopListMap);
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
    final now = DateTime.now().millisecondsSinceEpoch;
    final suggestionMap = suggestion.toMap();
    suggestionMap['created_at'] = now;
    suggestionMap['updated_at'] = now;

    return await db.insert("suggestions", suggestionMap);
  }

  Future<int> addShopListItem(ShopListItem shopListItem) async {
    Database db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final shopListItemMap = shopListItem.toMap();
    shopListItemMap['created_at'] = now;
    shopListItemMap['updated_at'] = now;
    if (shopListItem.checked) {
      shopListItemMap['checked_at'] = now;
    }
    return await db.insert("shop_list_items", shopListItemMap);
  }

  Future<int> setShopListItemChecked(int shopListItemId, bool checked) async {
    Database db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final updateMap = {
      "checked": checked ? 1 : 0,
      "updated_at": now,
    };
    if (checked) {
      updateMap["checked_at"] = now;
    }
    return await db.update(
      "shop_list_items",
      updateMap,
      where: "id = ?",
      whereArgs: [shopListItemId],
    );
  }

  Future<int> updateShopListItem(ShopListItem shopListItem) async {
    Database db = await instance.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final shopListItemMap = shopListItem.toMap();
    shopListItemMap['updated_at'] = now;
    if (shopListItem.checked) {
      shopListItemMap['checked_at'] = now;
    }
    return await db.update(
      "shop_list_items",
      shopListItemMap,
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
    final now = DateTime.now().millisecondsSinceEpoch;
    final updateMap = {
      "checked": checked ? 1 : 0,
      "updated_at": now,
    };
    if (checked) {
      updateMap["checked_at"] = now;
    }
    return await db.update(
      "shop_list_items",
      updateMap,
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

  Future<List<Map<String, dynamic>>> getFrequentlyBoughtItemsWithStatus({int limit = 5, required int shopListId}) async {
    Database db = await instance.database;
    
    String query = '''
      SELECT 
        items.name,
        COUNT(*) as frequency,
        CASE WHEN current_list.name IS NOT NULL THEN 1 ELSE 0 END as is_in_current_list,
        current_list.id as shop_list_item_id
      FROM shop_list_items items
      LEFT JOIN shop_list_items current_list 
        ON LOWER(items.name) = LOWER(current_list.name) 
        AND current_list.shop_list_id = ?
      GROUP BY LOWER(items.name)
      ORDER BY frequency DESC
      LIMIT ?
    ''';
    
    var result = await db.rawQuery(query, [shopListId, limit]);
    
    return result;
  }

  Future<Money?> getLastRecordedPrice(String itemName) async {
    Database db = await instance.database;
    
    var result = await db.query(
      'shop_list_items',
      columns: ['unit_price'],
      where: 'LOWER(name) = ? AND unit_price > 0',
      whereArgs: [itemName.toLowerCase()],
      orderBy: 'id DESC',
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return Money(cents: result.first['unit_price'] as int);
    }
    
    return null;
  }

  Future<void> generateMockData() async {
    final faker = Faker();
    
    // Common grocery items with realistic prices (in cents)
    final groceryItems = [
      {'name': 'Milk', 'price': 349},
      {'name': 'Bread', 'price': 289},
      {'name': 'Eggs', 'price': 425},
      {'name': 'Bananas', 'price': 159},
      {'name': 'Apples', 'price': 299},
      {'name': 'Chicken Breast', 'price': 899},
      {'name': 'Ground Beef', 'price': 649},
      {'name': 'Cheese', 'price': 549},
      {'name': 'Yogurt', 'price': 199},
      {'name': 'Cereal', 'price': 459},
      {'name': 'Rice', 'price': 199},
      {'name': 'Pasta', 'price': 149},
      {'name': 'Tomatoes', 'price': 249},
      {'name': 'Onions', 'price': 99},
      {'name': 'Potatoes', 'price': 179},
      {'name': 'Carrots', 'price': 129},
      {'name': 'Spinach', 'price': 299},
      {'name': 'Orange Juice', 'price': 399},
      {'name': 'Butter', 'price': 449},
      {'name': 'Olive Oil', 'price': 699},
      {'name': 'Salt', 'price': 99},
      {'name': 'Sugar', 'price': 199},
      {'name': 'Flour', 'price': 299},
      {'name': 'Salmon', 'price': 1299},
      {'name': 'Avocado', 'price': 199},
      {'name': 'Bell Peppers', 'price': 349},
      {'name': 'Broccoli', 'price': 229},
      {'name': 'Strawberries', 'price': 449},
      {'name': 'Blueberries', 'price': 599},
      {'name': 'Peanut Butter', 'price': 399},
    ];

    // Create suggestions for all grocery items
    for (final item in groceryItems) {
      await addSuggestion(item['name'] as String);
    }

    // Generate shopping lists across the year
    final currentYear = DateTime.now().year;
    final shopListNames = [
      'Weekly Groceries',
      'Weekend Shopping',
      'Monthly Stock-up',
      'Party Supplies',
      'Holiday Shopping',
      'Quick Run',
      'Bulk Shopping',
      'Healthy Meals',
      'Snack Run',
      'Dinner Ingredients',
    ];

    for (int month = 1; month <= 12; month++) {
      // Generate 3-8 shopping lists per month
      final listsInMonth = faker.randomGenerator.integer(6, min: 3);
      
      for (int listIndex = 0; listIndex < listsInMonth; listIndex++) {
        // Create shopping list
        final listName = shopListNames[faker.randomGenerator.integer(shopListNames.length)];
        final dayOfMonth = faker.randomGenerator.integer(28, min: 1);
        final listNameWithDate = '$listName - $month/$dayOfMonth';
        
        final shopList = ShopList(name: listNameWithDate);
        final shopListId = await addShopList(shopList);
        
        // Generate 3-15 items per shopping list
        final itemsInList = faker.randomGenerator.integer(13, min: 3);
        final usedItems = <String>{};
        
        for (int itemIndex = 0; itemIndex < itemsInList; itemIndex++) {
          // Pick a random grocery item that hasn't been used in this list
          Map<String, dynamic> selectedItem;
          do {
            selectedItem = groceryItems[faker.randomGenerator.integer(groceryItems.length)];
          } while (usedItems.contains(selectedItem['name']));
          
          usedItems.add(selectedItem['name'] as String);
          
          // Generate realistic quantity (1-5 for most items)
          final quantity = Decimal.fromInt(faker.randomGenerator.integer(5, min: 1));
          
          // Add some price variation (±20%)
          final basePrice = selectedItem['price'] as int;
          final priceVariation = (basePrice * 0.2).round();
          final finalPrice = basePrice + faker.randomGenerator.integer(priceVariation * 2, min: -priceVariation);
          
          // 70% chance the item is checked (purchased)
          final isChecked = faker.randomGenerator.boolean();
          
          final item = ShopListItem(
            shopListId: shopListId,
            name: selectedItem['name'] as String,
            quantity: quantity,
            unitPrice: Money(cents: finalPrice),
            checked: isChecked,
          );
          
          await addShopListItem(item);
        }
      }
    }
    
    // Generate some additional seasonal items
    await _generateSeasonalItems(faker, currentYear);
  }

  Future<void> _generateSeasonalItems(Faker faker, int year) async {
    // Holiday shopping lists
    final holidayLists = [
      {'name': 'Christmas Shopping', 'month': 12, 'items': ['Turkey', 'Cranberries', 'Stuffing Mix', 'Pumpkin Pie', 'Eggnog']},
      {'name': 'Thanksgiving Prep', 'month': 11, 'items': ['Turkey', 'Sweet Potatoes', 'Green Beans', 'Pie Crust', 'Gravy']},
      {'name': 'Summer BBQ', 'month': 7, 'items': ['Hamburger Buns', 'Hot Dogs', 'Charcoal', 'Corn on the Cob', 'Watermelon']},
      {'name': 'Back to School', 'month': 8, 'items': ['Lunch Bags', 'Granola Bars', 'Juice Boxes', 'Sandwich Bread', 'Peanut Butter']},
    ];

    // Create suggestions for all seasonal items
    final allSeasonalItems = <String>{};
    for (final holiday in holidayLists) {
      final items = holiday['items'] as List<String>;
      allSeasonalItems.addAll(items);
    }
    
    for (final itemName in allSeasonalItems) {
      await addSuggestion(itemName);
    }

    for (final holiday in holidayLists) {
      final shopList = ShopList(name: holiday['name'] as String);
      final shopListId = await addShopList(shopList);
      
      final items = holiday['items'] as List<String>;
      for (final itemName in items) {
        final quantity = Decimal.fromInt(faker.randomGenerator.integer(3, min: 1));
        final price = faker.randomGenerator.integer(800, min: 200);
        final isChecked = faker.randomGenerator.boolean();
        
        final item = ShopListItem(
          shopListId: shopListId,
          name: itemName,
          quantity: quantity,
          unitPrice: Money(cents: price),
          checked: isChecked,
        );
        
        await addShopListItem(item);
      }
    }
  }

}