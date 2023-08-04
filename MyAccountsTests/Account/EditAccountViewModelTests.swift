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
import SwiftUI

final class EditAccountViewModelTests: BaseTest {
    let model = EditAccountViewModel()
    var database = Database(name: "")

    override func setUpWithError() throws {
        try super.setUpWithError()
        database = Database(name: "main", accounts: [account.accountName: account])
        let dbBinding = Binding(get: { self.database }, set: { self.database = $0 })
        var isPresented = false
        model.isPresented = Binding(get: {isPresented}, set: { isPresented = $0 })
        model.initialize(
            account: account,
            database: dbBinding
        )
    }

    func testAttachFiles() throws {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "testfile", ofType: "txt")!
        try FileManager.default.copyItem(atPath: path, toPath: Database.srcDir + "/testfile.txt")
        // TODO: test replacing file1 with testfile.txt
        // TODO: write func to copy from bundle to a path

        model.attachFile(Result {
            URL(filePath: "\(Database.srcDir)/testfile.txt")
        })
        model.willDetachFile("file1")
        model.detachFile()
        model.createAccount()

        XCTAssertEqual(
            database.accounts["gmail"]?.attachedFiles,
            [
                // the new file should be loaded
                "testfile.txt": "SGVsbG8sIHdvcmxkIQo=",
                // the already attached file should be retained
                "file2": account.attachedFiles["file2"]!
            ]
        )
    }
}
