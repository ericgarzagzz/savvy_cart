import 'dart:async';

import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/models/suggestion.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'domain/models/shop_list_item.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(
      await _getDatabasePath(),
      version: 1,
      onCreate: _onCreate
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

  Future<List<ShopList>> getShopLists() async {
    Database db = await instance.database;
    var shopLists = await db.query("shop_lists", orderBy: "id DESC");
    List<ShopList> shopListCollection = shopLists.isNotEmpty
      ? shopLists.map((x) => ShopList.fromMap(x)).toList()
      : [];
    return shopListCollection;
  }

  Future<ShopList?> getShopListById(int id) async {
    await Future.delayed(Duration(seconds: 3));
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

  Future<bool> shopListItemExists(int shopListId, String itemName) async {
    Database db = await instance.database;
    var existing = await db.query(
      'shop_list_items',
      where: 'shop_list_id = ? AND LOWER(name) = ?',
      whereArgs: [shopListId, itemName.toLowerCase()],
    );
    return existing.isNotEmpty;
  }
  
  Future<int> removeShopList(int id) async {
    Database db = await instance.database;
    return db.delete("shop_lists", where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeShopListItem(int id) async {
    Database db = await instance.database;
    return await db.delete("shop_list_items", where: "id = ?", whereArgs: [id]);
  }
}