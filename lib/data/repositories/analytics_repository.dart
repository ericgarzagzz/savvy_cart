import 'package:savvy_cart/data/database/base_repository.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsRepository extends BaseRepository {
  Future<Money> getTotalAmountLastWeek() async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final sevenDaysAgoMs = sevenDaysAgo.millisecondsSinceEpoch;

      var result = await db.rawQuery(
        '''
        SELECT SUM(sli.unit_price * sli.quantity) as total_cents
        FROM shop_list_items sli
        INNER JOIN shop_lists sl ON sli.shop_list_id = sl.id
        WHERE sl.created_at >= ? AND sli.checked = 1
      ''',
        [sevenDaysAgoMs],
      );

      final totalCents = (result.first['total_cents'] as num?)?.round() ?? 0;
      return Money(cents: totalCents);
    });
  }

  Future<List<FrequentlyBoughtItem>> getFrequentlyBoughtItemsLastMonth({
    int limit = 5,
  }) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final thirtyDaysAgoMs = thirtyDaysAgo.millisecondsSinceEpoch;

      var result = await db.rawQuery(
        '''
        SELECT sli.name, COUNT(*) as frequency
        FROM shop_list_items sli
        INNER JOIN shop_lists sl ON sli.shop_list_id = sl.id
        WHERE sl.created_at >= ? AND sli.checked = 1
        GROUP BY LOWER(sli.name)
        ORDER BY frequency DESC
        LIMIT ?
      ''',
        [thirtyDaysAgoMs, limit],
      );

      return result.map((map) => FrequentlyBoughtItem.fromMap(map)).toList();
    });
  }

  Future<List<PriceHistoryEntry>> getItemPriceHistory(
    String itemName, {
    int limit = 5,
  }) async {
    return handleDatabaseOperation(() async {
      Database db = await database;

      var result = await db.rawQuery(
        '''
        SELECT sli.unit_price, sl.created_at
        FROM shop_list_items sli
        INNER JOIN shop_lists sl ON sli.shop_list_id = sl.id
        WHERE LOWER(sli.name) = LOWER(?) AND sli.unit_price > 0 AND sli.checked = 1
        ORDER BY sl.created_at DESC
        LIMIT ?
      ''',
        [itemName, limit],
      );

      return result.map((map) => PriceHistoryEntry.fromMap(map)).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getFrequentlyBoughtItemsWithStatus({
    int limit = 5,
    required int shopListId,
  }) async {
    return handleDatabaseOperation(() async {
      Database db = await database;

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
    });
  }
}
