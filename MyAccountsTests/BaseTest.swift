// Copyright (C) 2023. Bohdan Kolvakh
// This file is part of MyAccounts.
// 
// MyAccounts is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import XCTest
@testable import MyAccounts

open class BaseTest: XCTestCase {
    let filemgr = FileManager.default

    func setupSrcDir() throws {
        try? filemgr.removeItem(atPath: Database.srcDir)
        try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: false)
        print("SRC_DIR: \(Database.srcDir)")
    }

    func copyFile(_ name: String, as newName: String = "") throws {
        var newName = newName
        if newName.isEmpty { newName = name }
        let bundle = Bundle(for: type(of: self))
        let comps = name.components(separatedBy: ".")
        let path = bundle.path(forResource: comps[0], ofType: comps[1])!
        try FileManager.default.copyItem(atPath: path, toPath: Database.srcDir + "/\(newName)")
    }

    func copyDatabase(as name: String = "main") throws {
        try copyFile("main.dba", as: "\(name).dba")
    }

    open override func setUpWithError() throws {
        try setupSrcDir()
    }
}
