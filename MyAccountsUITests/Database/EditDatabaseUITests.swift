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

final class EditDatabaseUITests: BaseTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["test"].swipeLeft()
        app.buttons["EditDB".l("test")].tap()
    }

    func testEditDatabase() throws {
        // all fields should be prefilled
        let name = app.textFields["DBName".l].value as? String
        let password = app.textFields["Password".l].value as? String
        let repeatPassword = app.textFields["RepeatPassword".l].value as? String
        XCTAssertEqual(name, "test")
        XCTAssertEqual(password, "123")
        XCTAssertEqual(repeatPassword, "123")

        // there should be no name error since it's fine for name to stay unchanged throughout editing
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(app.buttons["Save".l].isEnabled)

        // but if we change the name to a taken name, the error should appear
        app.textFields["DBName".l].replaceText(with: "main")
        XCTAssert(app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.buttons["Save".l].isEnabled)

        // edit the database and save it
        app.textFields["DBName".l].replaceText(with: "test2")
        app.secureTextFields["Password".l].replaceText(with: "abc")
        app.secureTextFields["RepeatPassword".l].replaceText(with: "abc")
        app.buttons["Save".l].tap()

        // `test2` should appear in the list instead of `test`
        XCTAssert(app.staticTexts["test2"].exists)
        XCTAssert(!app.staticTexts["test"].exists)

        // as well as the other databases
        XCTAssert(app.staticTexts["main"].exists)
        XCTAssert(app.staticTexts["unsaved"].exists)

        // the database should be opened, so close it now
        app.staticTexts["test2"].swipeLeft()
        app.buttons["CloseDB".l("test2")].tap()

        // try to open it using the new password
        app.staticTexts["test2"].tap()
        app.secureTextFields["Password"].writeText("abc")
        app.buttons["OpenDBButton".l].tap()

        // you should be redirected to AccountsList
        XCTAssert(!app.staticTexts["OpenDB".l("test2")].exists)
        XCTAssert(app.navigationBars["test2"].exists)
        XCTAssert(app.staticTexts["gmail"].exists)
        XCTAssert(app.staticTexts["mega"].exists)

        // edit `test2` again, this time without renaming it
        goBack()
        app.staticTexts["test2"].swipeLeft()
        app.buttons["EditDB".l("test2")].tap()
        app.secureTextFields["Password".l].replaceText(with: "321")
        app.secureTextFields["RepeatPassword".l].replaceText(with: "321")
        app.buttons["Save".l].tap()

        // `test2` should still be in the list
        XCTAssert(app.staticTexts["test2"].exists)
        XCTAssert(app.staticTexts["main"].exists)
        XCTAssert(app.staticTexts["unsaved"].exists)

        // close it
        app.staticTexts["test2"].swipeLeft()
        app.buttons["CloseDB".l("test2")].tap()

        // opening it should work
        app.staticTexts["test2"].tap()
        app.secureTextFields["Password"].writeText("321")
        app.buttons["OpenDBButton".l].tap()

        // you should be redirected to AccountsList
        XCTAssert(!app.staticTexts["OpenDB".l("test2")].exists)
        XCTAssert(app.navigationBars["test2"].exists)
        XCTAssert(app.staticTexts["gmail"].exists)
        XCTAssert(app.staticTexts["mega"].exists)
    }
}
