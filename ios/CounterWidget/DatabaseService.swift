//
//  DatabaseService.swift
//  CounterWidgetExtension
//
//  Created by tsinis on 14.08.2022.
//

import Foundation
import SQLite3

struct DatabaseService {
    private let dbPath: String = "database.db"
    private var db: OpaquePointer?

    init() {
        db = openDatabase()
    }

    func getCount() -> String? {
        var resultCount: String?
        let queryStatementInt = "SELECT value FROM counter;"
        var queryStatement: OpaquePointer?
        let sqlState = sqlite3_prepare_v2(db, queryStatementInt, -1, &queryStatement, nil)
        if sqlState == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let value = sqlite3_column_int(queryStatement, 0)
                resultCount = String(describing: value)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return resultCount
    }

    private func openDatabase() -> OpaquePointer? {
        let fileManager = FileManager.default
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.example.flutterWidgetkit")
        let dbFile = directory!.appendingPathComponent(dbPath)
        var db: OpaquePointer?
        if sqlite3_open(dbFile.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
}