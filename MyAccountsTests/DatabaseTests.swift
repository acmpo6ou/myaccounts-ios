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
        XCTAssertTrue(try db.isSaved)

        db.accounts["gmail"] = nil
        XCTAssertFalse(try db.isSaved)
    }
}
