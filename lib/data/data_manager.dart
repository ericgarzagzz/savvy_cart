import 'package:sqflite/sqflite.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'repositories/shop_list_repository.dart';
import 'repositories/shop_list_item_repository.dart';
import 'repositories/chat_message_repository.dart';
import 'repositories/suggestion_repository.dart';
import 'repositories/analytics_repository.dart';
import 'services/mock_data_service.dart';
import 'database/database_manager.dart';

class DataManager {
  DataManager._privateConstructor();
  static final DataManager instance = DataManager._privateConstructor();

  final ShopListRepository shopLists = ShopListRepository();
  final ShopListItemRepository shopListItems = ShopListItemRepository();
  final ChatMessageRepository chatMessages = ChatMessageRepository();
  final SuggestionRepository suggestions = SuggestionRepository();
  final AnalyticsRepository analytics = AnalyticsRepository();
  final MockDataService mockData = MockDataService.instance;

  Future<void> purgeDatabase() async {
    return DatabaseManager.instance.purgeDatabase();
  }

  Future<T> transaction<T>(
    Future<T> Function(TransactionContext) action,
  ) async {
    final db = await DatabaseManager.instance.database;
    return db.transaction<T>((txn) async {
      final context = TransactionContext(txn);
      return await action(context);
    });
  }

  Future<int> getDatabaseVersion() async {
    final db = await DatabaseManager.instance.database;
    return await db.getVersion();
  }

  Future<List<Map<String, dynamic>>> exportRawTableData(
    String tableName,
  ) async {
    final db = await DatabaseManager.instance.database;
    return await db.query(tableName);
  }

  Future<void> clearAllData() async {
    final db = await DatabaseManager.instance.database;
    await db.delete('chat_messages');
    await db.delete('shop_list_items');
    await db.delete('shop_lists');
    await db.delete('suggestions');
  }

  Future<void> importRawTableData(
    Map<String, List<Map<String, dynamic>>> data,
  ) async {
    final db = await DatabaseManager.instance.database;

    // Import in dependency order
    if (data.containsKey('shop_lists')) {
      for (var item in data['shop_lists']!) {
        await db.insert('shop_lists', item);
      }
    }

    if (data.containsKey('shop_list_items')) {
      for (var item in data['shop_list_items']!) {
        await db.insert('shop_list_items', item);
      }
    }

    if (data.containsKey('suggestions')) {
      for (var item in data['suggestions']!) {
        await db.insert('suggestions', item);
      }
    }

    if (data.containsKey('chat_messages')) {
      for (var item in data['chat_messages']!) {
        await db.insert('chat_messages', item);
      }
    }
  }
}

class TransactionContext {
  final Transaction _transaction;

  TransactionContext(this._transaction);

  ShopListTransactionRepository get shopLists =>
      ShopListTransactionRepository(_transaction);
  ShopListItemTransactionRepository get shopListItems =>
      ShopListItemTransactionRepository(_transaction);
  ChatMessageTransactionRepository get chatMessages =>
      ChatMessageTransactionRepository(_transaction);
  SuggestionTransactionRepository get suggestions =>
      SuggestionTransactionRepository(_transaction);
}

// Transaction-aware repository implementations
class ShopListTransactionRepository {
  final Transaction _txn;
  ShopListTransactionRepository(this._txn);

  Future<int> add(ShopList shopList) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final shopListMap = shopList.toMap();
    shopListMap['created_at'] =
        shopList.createdAt?.millisecondsSinceEpoch ?? now;
    shopListMap['updated_at'] =
        shopList.updatedAt?.millisecondsSinceEpoch ?? now;
    return await _txn.insert("shop_lists", shopListMap);
  }

  Future<int> remove(int id) async {
    return _txn.delete("shop_lists", where: "id = ?", whereArgs: [id]);
  }
}

class ShopListItemTransactionRepository {
  final Transaction _txn;
  ShopListItemTransactionRepository(this._txn);

  Future<int> add(ShopListItem shopListItem) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final shopListItemMap = shopListItem.toMap();
    shopListItemMap['created_at'] = now;
    shopListItemMap['updated_at'] = now;
    if (shopListItem.checked) {
      shopListItemMap['checked_at'] = now;
    }
    return await _txn.insert("shop_list_items", shopListItemMap);
  }

  Future<List<int>> addBatch(List<ShopListItem> items) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final results = <int>[];

    for (final item in items) {
      final itemMap = item.toMap();
      itemMap['created_at'] = now;
      itemMap['updated_at'] = now;
      if (item.checked) {
        itemMap['checked_at'] = now;
      }
      final result = await _txn.insert("shop_list_items", itemMap);
      results.add(result);
    }

    return results;
  }
}

class ChatMessageTransactionRepository {
  final Transaction _txn;
  ChatMessageTransactionRepository(this._txn);

  Future<int> add(ChatMessage chatMessage) async {
    return await _txn.insert("chat_messages", chatMessage.toMap());
  }
}

class SuggestionTransactionRepository {
  final Transaction _txn;
  SuggestionTransactionRepository(this._txn);

  Future<int> add(String name) async {
    var existing = await _txn.query(
      'suggestions',
      where: 'LOWER(name) = ?',
      whereArgs: [name.toLowerCase()],
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    var suggestion = Suggestion(name: name.toLowerCase());
    final now = DateTime.now().millisecondsSinceEpoch;
    final suggestionMap = suggestion.toMap();
    suggestionMap['created_at'] = now;
    suggestionMap['updated_at'] = now;

    return await _txn.insert("suggestions", suggestionMap);
  }
}
