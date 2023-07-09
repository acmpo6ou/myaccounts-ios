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
    }
    
    func copyDatabase(_ name: String) throws {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: name, ofType: "dba")!
        try FileManager.default.copyItem(atPath: path, toPath: Database.srcDir + "/\(name).dba")
    }

    override func setUpWithError() throws {
        try setupSrcDir()
        try copyDatabase("main")
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let db = Database(name: "main", password: "123")
        try db.create()
    }
}
