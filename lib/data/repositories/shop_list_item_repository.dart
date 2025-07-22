import 'package:decimal/decimal.dart';
import 'package:savvy_cart/data/database/base_repository.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:sqflite/sqflite.dart';

class ShopListItemRepository extends BaseRepository {
  Future<List<ShopListItem>> getByShopListId(int shopListId) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        "shop_list_items",
        where: 'shop_list_id = ?',
        whereArgs: [shopListId],
      );
      return result.map((x) => ShopListItem.fromMap(x)).toList();
    });
  }

  Future<List<ShopListItem>> getByShopListIdAndStatus(
    int shopListId,
    bool checked,
  ) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        "shop_list_items",
        where: 'shop_list_id = ? AND checked = ?',
        whereArgs: [shopListId, checked ? 1 : 0],
      );
      return result.map((x) => ShopListItem.fromMap(x)).toList();
    });
  }

  Future<ShopListItem?> getById(int id) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        'shop_list_items',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return ShopListItem.fromMap(result.first);
      }
      return null;
    });
  }

  Future<ShopListItem?> getByName(int shopListId, String name) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        'shop_list_items',
        where: 'shop_list_id = ? AND LOWER(name) = LOWER(?)',
        whereArgs: [shopListId, name],
      );
      if (result.isNotEmpty) {
        return ShopListItem.fromMap(result.first);
      }
      return null;
    });
  }

  Future<bool> exists(int shopListId, String itemName) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        'shop_list_items',
        where: 'shop_list_id = ? AND LOWER(name) = ?',
        whereArgs: [shopListId, itemName.toLowerCase()],
      );
      return result.isNotEmpty;
    });
  }

  Future<int> add(ShopListItem shopListItem) async {
    return handleInsertOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final shopListItemMap = shopListItem.toMap();
      shopListItemMap['created_at'] = now;
      shopListItemMap['updated_at'] = now;
      if (shopListItem.checked) {
        shopListItemMap['checked_at'] = now;
      }
      return await db.insert("shop_list_items", shopListItemMap);
    });
  }

  Future<int> update(ShopListItem shopListItem) async {
    return handleUpdateOperation(() async {
      Database db = await database;
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
    });
  }

  Future<int> updateByName(
    int shopListId,
    String name, {
    Decimal? quantity,
    Money? unitPrice,
    bool? checked,
  }) async {
    return handleUpdateOperation(() async {
      final existingItem = await getByName(shopListId, name);

      if (existingItem != null) {
        final updatedItem = existingItem.copyWith(
          quantity: quantity ?? existingItem.quantity,
          unitPrice: unitPrice ?? existingItem.unitPrice,
          checked: checked ?? existingItem.checked,
        );
        return await update(updatedItem);
      } else {
        return await add(
          ShopListItem(
            shopListId: shopListId,
            name: name,
            quantity: quantity ?? Decimal.one,
            unitPrice: unitPrice ?? Money(cents: 0),
            checked: checked ?? false,
          ),
        );
      }
    });
  }

  Future<int> setChecked(int shopListItemId, bool checked) async {
    return handleUpdateOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final updateMap = {"checked": checked ? 1 : 0, "updated_at": now};
      if (checked) {
        updateMap["checked_at"] = now;
      }
      return await db.update(
        "shop_list_items",
        updateMap,
        where: "id = ?",
        whereArgs: [shopListItemId],
      );
    });
  }

  Future<int> setCheckedByName(
    int shopListId,
    String name,
    bool checked,
  ) async {
    return handleUpdateOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final updateMap = {"checked": checked ? 1 : 0, "updated_at": now};
      if (checked) {
        updateMap["checked_at"] = now;
      }
      return await db.update(
        "shop_list_items",
        updateMap,
        where: "shop_list_id = ? AND LOWER(name) = LOWER(?)",
        whereArgs: [shopListId, name],
      );
    });
  }

  Future<int> remove(int id) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return await db.delete(
        "shop_list_items",
        where: "id = ?",
        whereArgs: [id],
      );
    });
  }

  Future<int> removeByName(int shopListId, String name) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return await db.delete(
        "shop_list_items",
        where: "shop_list_id = ? AND LOWER(name) = LOWER(?)",
        whereArgs: [shopListId, name],
      );
    });
  }

  Future<Money> calculateCheckedAmount(int shopListId) async {
    return handleDatabaseOperation(() async {
      var shopListItems = await getByShopListId(shopListId);
      return shopListItems
          .where((x) => x.checked)
          .fold<Money>(
            Money(cents: 0),
            (prev, current) => prev + (current.unitPrice * current.quantity),
          );
    });
  }

  Future<(int checkedCount, int totalCount)> calculateItemCounts(
    int shopListId,
  ) async {
    return handleDatabaseOperation(() async {
      final shopListItems = await getByShopListId(shopListId);

      final int totalCount = shopListItems.length;
      final int checkedCount = shopListItems
          .where((item) => item.checked)
          .length;

      return (checkedCount, totalCount);
    });
  }

  Future<(Money uncheckedAmount, Money checkedAmount)> calculateItemStats(
    int shopListId,
  ) async {
    return handleDatabaseOperation(() async {
      final shopListItems = await getByShopListId(shopListId);

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
    });
  }

  Future<Money?> getLastRecordedPrice(String itemName) async {
    return handleDatabaseOperation(() async {
      Database db = await database;

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
    });
  }

  Future<List<int>> addBatch(List<ShopListItem> items) async {
    return handleInsertOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final batch = db.batch();

      for (final item in items) {
        final itemMap = item.toMap();
        itemMap['created_at'] = now;
        itemMap['updated_at'] = now;
        if (item.checked) {
          itemMap['checked_at'] = now;
        }
        batch.insert("shop_list_items", itemMap);
      }

      final results = await batch.commit(noResult: false);
      return results.cast<int>();
    });
  }

  Future<List<int>> updateBatch(List<ShopListItem> items) async {
    return handleUpdateOperation(() async {
      Database db = await database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final batch = db.batch();

      for (final item in items) {
        final itemMap = item.toMap();
        itemMap['updated_at'] = now;
        if (item.checked) {
          itemMap['checked_at'] = now;
        }
        batch.update(
          "shop_list_items",
          itemMap,
          where: "id = ?",
          whereArgs: [item.id],
        );
      }

      final results = await batch.commit(noResult: false);
      return results.cast<int>();
    });
  }
}
