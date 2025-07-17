import 'dart:io';

/// Custom exceptions for file I/O operations
abstract class FileIOException implements Exception {
  final String message;
  final dynamic originalError;
  
  const FileIOException(this.message, [this.originalError]);
  
  @override
  String toString() => 'FileIOException: $message';
}

class FileNotFoundIOException extends FileIOException {
  const FileNotFoundIOException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'FileNotFoundIOException: $message';
}

class FilePermissionException extends FileIOException {
  const FilePermissionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'FilePermissionException: $message';
}

class InsufficientStorageException extends FileIOException {
  const InsufficientStorageException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'InsufficientStorageException: $message';
}

class FileCorruptionException extends FileIOException {
  const FileCorruptionException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'FileCorruptionException: $message';
}

class BackupCreationException extends FileIOException {
  const BackupCreationException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'BackupCreationException: $message';
}

class BackupRestoreException extends FileIOException {
  const BackupRestoreException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'BackupRestoreException: $message';
}

class InvalidBackupFormatException extends FileIOException {
  const InvalidBackupFormatException(String message, [dynamic originalError])
      : super(message, originalError);
      
  @override
  String toString() => 'InvalidBackupFormatException: $message';
}

/// Helper class to analyze file system errors and throw appropriate exceptions
class FileIOErrorHandler {
  static void handleFileSystemException(FileSystemException e) {
    final message = e.message.toLowerCase();
    
    if (message.contains('permission denied') || message.contains('access denied')) {
      throw FilePermissionException('Access denied: ${e.message}', e);
    }
    
    if (message.contains('no such file') || message.contains('file not found')) {
      throw FileNotFoundIOException('File not found: ${e.path}', e);
    }
    
    if (message.contains('no space left') || message.contains('disk full')) {
      throw InsufficientStorageException('Insufficient storage space', e);
    }
    
    if (message.contains('read-only')) {
      throw FilePermissionException('Cannot write to read-only location: ${e.path}', e);
    }
    
    // Generic file system error
    throw FilePermissionException('File system error: ${e.message}', e);
  }
  
  static void handleFormatException(FormatException e, String context) {
    if (context == 'backup') {
      throw InvalidBackupFormatException('Invalid backup file format: ${e.message}', e);
    }
    throw FileCorruptionException('File format error: ${e.message}', e);
  }
  
  static void handlePathAccessException(String path) {
    throw FilePermissionException('Cannot access path: $path');
  }
  
  static void validateBackupFile(File file) {
    if (!file.path.endsWith('.json')) {
      throw InvalidBackupFormatException('Backup file must have .json extension');
    }
  }
}