import 'package:savvy_cart/data/database/base_repository.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ChatMessageRepository extends BaseRepository {
  Future<List<ChatMessage>> getByShopListId(int shopListId) async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query(
        "chat_messages",
        where: 'shop_list_id = ?',
        whereArgs: [shopListId],
        orderBy: 'timestamp ASC',
      );
      return result.map((x) => ChatMessage.fromMap(x)).toList();
    });
  }

  Future<int> add(ChatMessage chatMessage) async {
    return handleInsertOperation(() async {
      Database db = await database;
      return await db.insert("chat_messages", chatMessage.toMap());
    });
  }

  Future<int> remove(int id) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return await db.delete("chat_messages", where: "id = ?", whereArgs: [id]);
    });
  }

  Future<int> removeByShopListId(int shopListId) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return await db.delete(
        "chat_messages",
        where: "shop_list_id = ?",
        whereArgs: [shopListId],
      );
    });
  }

  Future<int> markActionsExecuted(
    int chatMessageId,
    String executedActionsJson,
  ) async {
    return handleUpdateOperation(() async {
      Database db = await database;
      return await db.update(
        "chat_messages",
        {"actions_executed": 1, "executed_actions_json": executedActionsJson},
        where: "id = ?",
        whereArgs: [chatMessageId],
      );
    });
  }
}
