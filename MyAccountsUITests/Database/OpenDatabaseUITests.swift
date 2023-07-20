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

final class OpenDatabaseUITests: BaseTest {
    func testOpenDatabase() throws {
        // select `main` database
        app.staticTexts["main"].tap()

        // OpenDatabase shuould appear with correct title
        XCTAssert(app.staticTexts["OpenDB".l("main")].exists)

        // enter incorrect password
        app.secureTextFields["Password"].writeText("321")
        app.buttons["OpenDBButton".l].tap()

        // an error message should appear
        XCTAssert(app.staticTexts["BadPass".l].exists)

        // the message should disappear as soon as user starts typing
        app.secureTextFields["Password"].writeText("1")
        XCTAssert(!app.staticTexts["BadPass".l].exists)

        // enter correct password
        app.secureTextFields["Password"].replaceText(with: "123")
        app.buttons["OpenDBButton".l].tap()

        // You should be redirected to AccountsList
        // TODO: check accounts
        XCTAssert(!app.staticTexts["OpenDB".l("main")].exists)
        XCTAssert(app.navigationBars["main"].exists)
    }
}
