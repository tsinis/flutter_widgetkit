import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;

class SqlDatabase {
  const SqlDatabase._(this._database);

  final Database _database;

  static const _dbName = 'database.db';
  static const _id = 'id';
  static const _table = 'counter';
  static const _value = 'value';

  Future<int?> get count async {
    final map = await _database.query(_table);
    if (map.isEmpty) return null;
    final maybeCount = map.first[_value];

    return int.tryParse('$maybeCount');
  }

  static Future<SqlDatabase> get open async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final db = await openDatabase(
      join(documentDirectory.path, _dbName),
      version: 1,
      onCreate: (db, _) => db.execute("""
          CREATE TABLE $_table(
            $_id TEXT PRIMARY KEY,
            $_value INTEGER
          )
        """),
    );

    return SqlDatabase._(db);
  }

  Future<int> updateCount(int count) async => _database.insert(
        _table,
        {_id: _id, _value: count},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
