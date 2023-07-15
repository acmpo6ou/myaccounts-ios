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

final class DatabasesListViewModelTests: BaseTest {
    let model = DatabasesListViewModel()

    func testLoadDatabases() throws {
        // this should load `main` and `test` databases
        try copyDatabase()
        try copyDatabase(as: "test")
        model.loadDatabases()
        XCTAssertEqual(model.databases, [Database(name: "main"), Database(name: "test")])

        // now open `test`, and add a new database to source folder
        try model.databases[1].open(with: "123")
        try copyDatabase(as: "crypt")

        // refresh
        model.loadDatabases()

        // `crypt` should be added to the list, and `test` should still be opened
        XCTAssertEqual(
            model.databases,
            [
                Database(name: "crypt"),
                Database(name: "main"),
                Database(name: "test", password: "123", accounts: accounts)
            ]
        )
    }
}
