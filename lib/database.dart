import 'package:app_group_directory/app_group_directory.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;

class SqlDatabase {
  const SqlDatabase._(this._database);

  final Database _database;

  static const _appGroupId = 'group.com.example.flutterWidgetkit';
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
    final directory = await AppGroupDirectory.getAppGroupDirectory(_appGroupId);
    if (directory == null) throw Exception('App Group $_appGroupId not found!');
    final db = await openDatabase(
      join(directory.path, _dbName),
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
