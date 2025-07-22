import 'package:savvy_cart/data/database/base_repository.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:sqflite/sqflite.dart';

class SuggestionRepository extends BaseRepository {
  Future<List<Suggestion>> getAll() async {
    return handleDatabaseOperation(() async {
      Database db = await database;
      var result = await db.query("suggestions", orderBy: "name ASC");
      return result.map((x) => Suggestion.fromMap(x)).toList();
    });
  }

  Future<int> add(String name) async {
    return handleInsertOperation(() async {
      Database db = await database;

      var existing = await db.query(
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

      return await db.insert("suggestions", suggestionMap);
    });
  }

  Future<int> removeByName(String name) async {
    return handleDeleteOperation(() async {
      Database db = await database;
      return await db.delete(
        "suggestions",
        where: "LOWER(name) = LOWER(?)",
        whereArgs: [name],
      );
    });
  }
}
