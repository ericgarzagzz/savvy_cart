import 'dart:async';
import 'package:savvy_cart/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';

abstract class BaseRepository {
  Future<Database> get database => DatabaseManager.instance.database;

  Future<T> handleDatabaseOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateDataException('Unique constraint violation', e);
      }
      throw DataRetrievalException('Database operation failed: $e', e);
    } on FormatException catch (e) {
      throw DataCorruptionException('Data format error: ${e.message}', e);
    } on ArgumentError catch (e) {
      throw InvalidDataException('Invalid argument: ${e.message}', e);
    } catch (e) {
      throw DataRetrievalException('Unexpected database error: $e', e);
    }
  }

  Future<T> handleInsertOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateDataException('Record with this data already exists', e);
      }
      throw DataInsertionException('Failed to insert data: $e', e);
    } on ArgumentError catch (e) {
      throw InvalidDataException('Invalid data: ${e.message}', e);
    } catch (e) {
      throw DataInsertionException('Unexpected error during insertion: $e', e);
    }
  }

  Future<T> handleUpdateOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw DuplicateDataException('Update would create duplicate data', e);
      }
      throw DataUpdateException('Failed to update data: $e', e);
    } on ArgumentError catch (e) {
      throw InvalidDataException('Invalid update data: ${e.message}', e);
    } catch (e) {
      throw DataUpdateException('Unexpected error during update: $e', e);
    }
  }

  Future<T> handleDeleteOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      throw DataDeletionException('Failed to delete data: $e', e);
    } catch (e) {
      throw DataDeletionException('Unexpected error during deletion: $e', e);
    }
  }
}
