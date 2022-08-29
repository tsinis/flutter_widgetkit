//
//  DatabaseService.swift
//  CounterWidgetExtension
//
//  Created by tsinis on 14.08.2022.
//

import Foundation
import SQLite3

// Database Service for SQLite database, very similar to Dart's one:
// https://github.com/tsinis/flutter_widgetkit/blob/main/lib/database_service.dart
//
// Dart is using underscore for private fields, Swift is using private keyword.
struct DatabaseService {
    // Few constants to use in the database, the same as
    // in the Dart version of this class.
    private let queryStatementInt = "SELECT value FROM counter;"
    private let appGroupId = "group.com.example.flutterWidgetkit"
    private let dbPath: String = "database.db"

    // SQLite database to use, equivalent to Dart's Database `_db` field.
    private var db: OpaquePointer?

    // Convient Swift's method to initialize the class.
    init() {
        db = openDb()
    }

    // The same method as in the Dart class, reads a value from the database,
    // with a raw SQL query and checks existence of the "count" value. In the
    // Swift version, we are returning String since we are showing it as Text
    // on the home screen widget, but in Dart, we are returning integer since
    // we are increasing it with taps on the button.
    func getCount() -> String? {
        var maybeCount: String?
        var queryStatement: OpaquePointer?
        let sqlState = sqlite3_prepare_v2(db, queryStatementInt, -1, &queryStatement, nil)
        if sqlState == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let value = sqlite3_column_int(queryStatement, 0)
                maybeCount = String(describing: value)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)

        return maybeCount
    }

    // The same method as in Dart class, also opens a database from app group
    // directory and checks the existence of the database. On the Dart side
    // we are also creating the database if it's not exist (on the first run).
    private func openDb() -> OpaquePointer? {
        let fileManager = FileManager.default
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupId)
        let dbFile = directory!.appendingPathComponent(dbPath)
        var db: OpaquePointer?

        if sqlite3_open(dbFile.path, &db) != SQLITE_OK {
            print("Error opening database")

            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")

            return db
        }
    }
}
