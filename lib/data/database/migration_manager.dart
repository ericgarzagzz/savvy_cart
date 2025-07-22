import 'dart:async';
import 'package:savvy_cart/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class MigrationManager {
  MigrationManager._privateConstructor();
  static final MigrationManager instance =
      MigrationManager._privateConstructor();

  FutureOr<void> onCreate(Database db, int version) async {
    var batch = db.batch();

    try {
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

      await batch.commit(noResult: false);
    } on DatabaseException catch (e) {
      throw DatabaseSchemaException('Failed to create database schema: $e', e);
    } catch (e) {
      throw DatabaseSchemaException(
        'Unexpected error during database creation: $e',
        e,
      );
    }
  }

  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

    try {
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

      await batch.commit(noResult: false);
    } on DatabaseException catch (e) {
      throw DatabaseSchemaException(
        'Failed to upgrade database from version $oldVersion to $newVersion: $e',
        e,
      );
    } catch (e) {
      throw DatabaseSchemaException(
        'Unexpected error during database upgrade: $e',
        e,
      );
    }
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
}
