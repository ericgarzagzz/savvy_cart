import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';
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
        unit_price INTEGER NOT NULL
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

  Future<Money> calculateShopListCheckedAmount(int shopListId) async {
    var shopListItems = await getShopListItems(shopListId);
    return shopListItems.fold<Money>(Money(cents: 0), (prev, current) => prev + (current.unitPrice * current.quantity));
  }
}