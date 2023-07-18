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

final class CreateDatabaseUITests: BaseTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons["CreateDB".l].tap()
    }

    func testCreateDatabase() throws {
        // enter "main" in name field
        app.textFields["DBName".l].writeText("main")

        // name taken error should appear
        XCTAssert(app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)

        // clear name field
        app.textFields["DBName".l].clearText()

        // empty name error should appear
        XCTAssert(app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)

        // enter a valid name
        app.textFields["DBName".l].writeText("data")

        // there should be no name errors
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)

        // - MARK: Password fields

        // since password field is empty, there should be an error
        XCTAssert(app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)

        // type in a password
        app.secureTextFields["Password".l].writeText("123")

        // the error should change
        XCTAssert(app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)

        // type in the same password into `Repeat password` field
        app.secureTextFields["RepeatPassword".l].writeText("123")

        // there should be no password errors
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)

        // tap Create button
        app.buttons["Create"].tap()

        // the database should appear in the list
        XCTAssert(app.staticTexts["data"].exists)

        // the Create database form should be hidden
        XCTAssert(!app.textFields["DBName".l].exists)
    }

    func testCreateEnabled() throws {
        // at first, the create button should be disabled
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // when all data is correct, the button should be enabled
        app.textFields["DBName".l].writeText("data")
        app.secureTextFields["Password".l].writeText("123")
        app.secureTextFields["RepeatPassword".l].writeText("123")
        XCTAssert(app.buttons["Create".l].isEnabled)

        // it should be disabled when there is a name error
        app.textFields["DBName".l].clearText()
        XCTAssert(!app.buttons["Create".l].isEnabled)
        app.textFields["DBName".l].writeText("main")
        XCTAssert(!app.buttons["Create".l].isEnabled)
        app.textFields["DBName".l].replaceText(with: "data")
        XCTAssert(app.buttons["Create".l].isEnabled)

        // or a password error
        app.secureTextFields["Password".l].clearText()
        XCTAssert(!app.buttons["Create".l].isEnabled)
        app.secureTextFields["Password".l].replaceText(with: "321")
        XCTAssert(!app.buttons["Create".l].isEnabled)
        app.secureTextFields["Password".l].replaceText(with: "123")
        XCTAssert(app.buttons["Create".l].isEnabled)
    }

    func testFilterDBName() throws {
        app.textFields["DBName".l].writeText("clean name")
        XCTAssertEqual(app.textFields["DBName".l].value as? String, "clean name")

        app.textFields["DBName".l].replaceText(with: "-c/l(e)a%n. n$a!m*e_1")
        XCTAssertEqual(app.textFields["DBName".l].value as? String, "-cl(e)an. name_1")
    }
}
