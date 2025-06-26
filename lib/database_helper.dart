import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'savvy_cart_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    return db.execute('''
      CREATE TABLE shop_lists(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      );
      
      CREATE TABLE shop_list_items(
        id INTEGER PRIMARY KEY,
        shop_list_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity TEXT NOT NULL,
        unit_price INTEGER NOT NULL
      );
      
      CREATE TABLE suggestions(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      );
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
}