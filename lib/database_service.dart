import 'package:app_group_directory/app_group_directory.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart' show WidgetKit;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

/// Database Service for SQLite database, very similar to Swift's one:
/// https://github.com/tsinis/flutter_widgetkit/blob/main/ios/CounterWidget/DatabaseService.swift
///
/// Dart is using underscore for private fields, Swift is using private keyword.
class DatabaseService {
  /// Private constructor to prevent instantiation without calling
  /// async `openDb()` since Dart doesn't have async factories/constructors.
  const DatabaseService._(this._db);

  /// SQLite database to use, equivalent to Swift's OpaquePointer `db` field.
  final Database _db;

  /// Few constants to use in the database, the same as
  /// in Swift version of this class.
  static const _appGroupId = 'group.com.example.flutterWidgetkit';
  static const _dbPath = 'database.db';
  static const _queryStatementInt = "SELECT value FROM counter;";

  /// Those are not referenced in the Swift version of this class,
  /// because they are used for database creation and updating.
  static const _id = 'id';
  static const _table = 'counter';
  static const _value = 'value';

  /// Same method as in Swift class, reads a value from the database,
  /// with a raw SQL query and checking existence of the "count" value.
  /// In Swift version we are returning String since we are showing it
  /// as Text on home-screen widget, but in Dart we are returning integer
  /// since we are increasing it with a taps on the button.
  Future<int?> getCount() async {
    final map = await _db.rawQuery(_queryStatementInt);
    if (map.isEmpty) return null;
    final maybeCount = map.first[_value];

    return maybeCount is int ? maybeCount : null;
  }

  /// Same method as in Swift class, also opens a database from app group
  /// directory and checking existence of the database. On the Dart side
  /// we are also creating the database if it's not exists (on the first run).
  static Future<DatabaseService> openDb() async {
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

  /// This method is only provided on Dart side, since Swift's home-screen
  /// widget is in "read-only" mode and doesn't allow to update the count.
  Future<void> updateCount(int count) async {
    /// Insert new count to the database, if exists - just replaces it.
    await _db.insert(
      _table,
      {_id: _id, _value: count},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    /// This will trigger a rebuild of the Swift's home-screen widget.
    return WidgetKit.reloadAllTimelines();
  }
}
