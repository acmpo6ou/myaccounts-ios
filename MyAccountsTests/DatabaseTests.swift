//
//  DatabaseTests.swift
//  DatabaseTests
//
//  Created by Catalyst on 28/06/2023.
//

import XCTest
@testable import MyAccounts

final class DatabaseTests: XCTestCase {
    let filemgr = FileManager.default

    func setupSrcDir() throws {
        try? filemgr.removeItem(atPath: Database.srcDir)
        try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: false)
        print("SRC_DIR: \(Database.srcDir)")
    }

    func copyDatabase(_ name: String = "main") throws {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "dba")!
        try FileManager.default.copyItem(atPath: path, toPath: Database.srcDir + "/\(name).dba")
    }

    override func setUpWithError() throws {
        try setupSrcDir()
    }

    override func tearDownWithError() throws {
    }

    func testIsOpen() throws {
        let closed = Database(name: "closed")
        let opened = Database(name: "opened", password: "123")
        XCTAssertFalse(closed.isOpen)
        XCTAssertTrue(opened.isOpen)
    }

    func testOpen() throws {
        try copyDatabase()
        var db = Database(name: "main")
        try db.open(with: "123")
        XCTAssertEqual(db.accounts, accounts)
        XCTAssertEqual(db.password, "123")
    }

    func testClose() throws {
        var db = Database(name: "main", password: "123", accounts: accounts)
        db.close()
        XCTAssertNil(db.password)
        XCTAssertEqual(db.accounts, [:])
    }

    func testCreate() throws {
        var db = Database(name: "main", password: "123", accounts: accounts)
        try db.create()

        db.close()
        try db.open(with: "123")
        XCTAssertEqual(db.accounts, accounts)
    }

    func testRename() throws {
        try copyDatabase()
        var db = Database(name: "main")
        try db.rename(to: "crypt")
        XCTAssertTrue(filemgr.fileExists(atPath: "\(Database.srcDir)/crypt.dba"))
        XCTAssertFalse(filemgr.fileExists(atPath: "\(Database.srcDir)/main.dba"))
    }

    func testIsSaved() throws {
        try copyDatabase()
        var db = Database(name: "main", password: "123", accounts: accounts)
        XCTAssertTrue(db.isSaved)

        db.accounts["gmail"] = nil
        XCTAssertFalse(db.isSaved)
    }

    func testIsSavedWhenNoDatabase() throws {
        // `isSaved` should return false if the database on disk does not exist or there is another error
        let db = Database(name: "main", password: "123", accounts: accounts)
        XCTAssertFalse(db.isSaved)
    }

    func testSave() throws {
        try copyDatabase()
        var db = Database(name: "main")
        try db.open(with: "123")

        var newAccounts = accounts
        newAccounts["mega"] = nil
        _ = try db.save(name: "crypt", password: "321", accounts: newAccounts)

        var newDb = Database(name: "crypt")
        try newDb.open(with: "321")
        XCTAssertEqual(newDb.accounts, newAccounts)
        XCTAssertFalse(filemgr.fileExists(atPath: "\(Database.srcDir)/main.dba"))
    }

    /// Saving a database when its name didn't change.
    ///
    /// For `Database.save()`, it's important to first delete old database and then create new one,
    /// not the other way around. Because if the name of the database didn't change during saving,
    /// the database file will be removed.
    func testSaveWhenDatabaseNameDidntChange() throws {
        try copyDatabase()
        var db = Database(name: "main")
        try db.open(with: "123")

        var newAccounts = accounts
        newAccounts["mega"] = nil
        _ = try db.save(name: "main", password: "321", accounts: newAccounts)

        var newDb = Database(name: "main")
        try newDb.open(with: "321")
        XCTAssertEqual(newDb.accounts, newAccounts)
    }
}
