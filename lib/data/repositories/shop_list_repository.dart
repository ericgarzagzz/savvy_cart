import 'package:savvy_cart/data/database/base_repository.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ShopListRepository extends BaseRepository {
  Future<List<ShopList>> getAll() async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query("shop_lists", orderBy: "created_at DESC");
      return result.map((x) => ShopList.fromMap(x)).toList();
    });
  }

  Future<List<ShopList>> getPaginated({int limit = 3, int offset = 0}) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        "shop_lists",
        orderBy: "created_at DESC",
        limit: limit,
        offset: offset,
      );
      return result.map((x) => ShopList.fromMap(x)).toList();
    });
  }

  Future<int> getCount() async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.rawQuery(
        "SELECT COUNT(*) as count FROM shop_lists",
      );
      return result.first['count'] as int;
    });
  }

  Future<List<ShopList>> search({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    return handleDatabaseOperation(() async {
      Database db = await database;

      List<String> whereConditions = [];
      List<dynamic> whereArgs = [];

      if (query != null && query.isNotEmpty) {
        whereConditions.add("name LIKE ?");
        whereArgs.add("%$query%");
      }

      if (startDate != null) {
        whereConditions.add("created_at >= ?");
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }

      if (endDate != null) {
        whereConditions.add("created_at <= ?");
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }

      String whereClause = whereConditions.isNotEmpty
          ? "WHERE ${whereConditions.join(' AND ')}"
          : "";

      var result = await db.query(
        "shop_lists",
        where: whereClause.isNotEmpty ? whereClause.substring(6) : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: "created_at DESC",
        limit: limit,
        offset: offset,
      );

      return result.map((x) => ShopList.fromMap(x)).toList();
    });
  }

  Future<ShopList?> getById(int id) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        'shop_lists',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return ShopList.fromMap(result.first);
      }
      return null;
    });
  }

  Future<int> add(ShopList shopList) async {
    return handleInsertOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final shopListMap = shopList.toMap();
      shopListMap['created_at'] =
          shopList.createdAt?.millisecondsSinceEpoch ?? now;
      shopListMap['updated_at'] =
          shopList.updatedAt?.millisecondsSinceEpoch ?? now;
      return await db.insert("shop_lists", shopListMap);
    });
  }

  Future<int> remove(int id) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return db.delete("shop_lists", where: "id = ?", whereArgs: [id]);
    });
  }

  Future<int> getCountLastWeek() async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final sevenDaysAgoMs = sevenDaysAgo.millisecondsSinceEpoch;

      var result = await db.rawQuery(
        "SELECT COUNT(*) as count FROM shop_lists WHERE created_at >= ?",
        [sevenDaysAgoMs],
      );
      return result.first['count'] as int;
    });
  }
}
