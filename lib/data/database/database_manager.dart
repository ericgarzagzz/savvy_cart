import 'dart:async';
import 'dart:io';
import 'package:savvy_cart/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'migration_manager.dart';

class DatabaseManager {
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    try {
      return await openDatabase(
        await _getDatabasePath(),
        version: 8,
        onCreate: MigrationManager.instance.onCreate,
        onUpgrade: MigrationManager.instance.onUpgrade,
      );
    } on DatabaseException catch (e) {
      throw DatabaseInitializationException(
        'Failed to initialize database: $e',
        e,
      );
    } on FileSystemException catch (e) {
      throw DatabaseInitializationException(
        'Database file system error: ${e.message}',
        e,
      );
    } catch (e) {
      throw DatabaseInitializationException(
        'Unexpected database initialization error: $e',
        e,
      );
    }
  }

  Future<String> _getDatabasePath() async {
    try {
      final path = await getDatabasesPath();
      return join(path, 'savvy_cart_database.db');
    } on FileSystemException catch (e) {
      throw DatabasePathException(
        'Cannot access database directory: ${e.message}',
        e,
      );
    } catch (e) {
      throw DatabasePathException(
        'Unexpected error getting database path: $e',
        e,
      );
    }
  }

  Future purgeDatabase() async {
    try {
      return deleteDatabase(await _getDatabasePath());
    } on FileSystemException catch (e) {
      throw DatabaseDeletionException(
        'Cannot delete database file: ${e.message}',
        e,
      );
    } catch (e) {
      throw DatabaseDeletionException(
        'Unexpected error deleting database: $e',
        e,
      );
    }
  }
}
