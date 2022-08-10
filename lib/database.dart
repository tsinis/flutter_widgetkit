import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:async';

class SqlDatabase {
  SqlDatabase._(this._database);
  final Database _database;

  static Future<SqlDatabase> load() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), "database.db"),
      version: 1,
      onCreate: (db, _) => db.execute("""
          CREATE TABLE counter(
            id TEXT PRIMARY KEY,
            value INTEGER
          )
        """),
    );

    return SqlDatabase._(db);
  }

  Future<int?> get count async {
    final List<Map<String, Object?>> map = await _database.query('counter');
    final maybeCount = map.first['value'];
    return int.tryParse('$maybeCount');
  }

  Future<void> updateCount(int count) async => _database.insert(
        'counter',
        {
          "id": 'id',
          "value": count,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
