import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart' show WidgetKit;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  const DatabaseService._(this._database);

  final Database _database;

  static const _appGroupId = 'group.com.example.flutterWidgetkit';
  static const _dbPath = 'database.db';
  static const _queryStatementInt = "SELECT value FROM counter;";
  static const _id = 'id';
  static const _table = 'counter';
  static const _value = 'value';

  Future<int?> get count async {
    final map = await _database.rawQuery(_queryStatementInt);
    if (map.isEmpty) return null;
    final maybeCount = map.first[_value];

    return maybeCount is int ? maybeCount : null;
  }

  static Future<DatabaseService> get openDb async {
    final directory = await AppGroupDirectory.getAppGroupDirectory(_appGroupId);
    if (directory == null) throw Exception('App Group $_appGroupId not found!');
    final database = await openDatabase(
      join(directory.path, _dbPath),
      version: 1,
      onCreate: (db, _) => db.execute(
        '''
          CREATE TABLE $_table(
            $_id TEXT PRIMARY KEY,
            $_value INTEGER
          )
        ''',
      ),
    );

    return DatabaseService._(database);
  }

  Future<void> updateCount(int count) async {
    await _database.insert(
      _table,
      {_id: _id, _value: count},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return WidgetKit.reloadAllTimelines();
  }
}
