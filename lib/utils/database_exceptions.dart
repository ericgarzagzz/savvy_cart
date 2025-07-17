import 'package:sqflite/sqflite.dart';

/// Extension to add helper methods to DatabaseException
extension DatabaseExceptionHelper on DatabaseException {
  bool isUniqueConstraintError() {
    return toString().toLowerCase().contains('unique constraint failed') ||
           toString().toLowerCase().contains('constraint failed');
  }
}

/// Custom exceptions for database operations
abstract class DatabaseOperationException implements Exception {
  final String message;
  final dynamic originalError;
  
  const DatabaseOperationException(this.message, [this.originalError]);
  
  @override
  String toString() => 'DatabaseOperationException: $message';
}

class DatabaseInitializationException extends DatabaseOperationException {
  const DatabaseInitializationException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DatabaseInitializationException: $message';
}

class DatabaseSchemaException extends DatabaseOperationException {
  const DatabaseSchemaException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DatabaseSchemaException: $message';
}

class DataRetrievalException extends DatabaseOperationException {
  const DataRetrievalException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DataRetrievalException: $message';
}

class DataInsertionException extends DatabaseOperationException {
  const DataInsertionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DataInsertionException: $message';
}

class DataUpdateException extends DatabaseOperationException {
  const DataUpdateException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DataUpdateException: $message';
}

class DataDeletionException extends DatabaseOperationException {
  const DataDeletionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DataDeletionException: $message';
}

class DataCorruptionException extends DatabaseOperationException {
  const DataCorruptionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DataCorruptionException: $message';
}

class DuplicateDataException extends DatabaseOperationException {
  const DuplicateDataException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DuplicateDataException: $message';
}

class InvalidDataException extends DatabaseOperationException {
  const InvalidDataException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'InvalidDataException: $message';
}

class SearchException extends DatabaseOperationException {
  const SearchException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'SearchException: $message';
}

class DatabasePathException extends DatabaseOperationException {
  const DatabasePathException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DatabasePathException: $message';
}

class DatabaseDeletionException extends DatabaseOperationException {
  const DatabaseDeletionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'DatabaseDeletionException: $message';
}