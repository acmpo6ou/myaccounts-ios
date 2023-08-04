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

final class CreateAccountUITests: BaseTest {

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["test"].tap()
        app.buttons["CreateAcc".l].tap()
    }

    func testCreateAccount() throws {
        // at the beginning, Create button should be disabled
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // enter a taken name into Account name field
        app.textFields["AccName".l].writeText("gmail")

        // name taken error should appear
        XCTAssert(app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // clear name field
        app.textFields["AccName".l].clearText()

        // empty name error should appear
        XCTAssert(app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // enter a valid name
        app.textFields["AccName".l].writeText("github")

        // there should be no name errors
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // - MARK: Password fields

        // since password field is empty, there should be an error
        XCTAssert(app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // type in a password
        app.secureTextFields["Password".l].writeText("123")

        // the error should change
        XCTAssert(app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.buttons["Create".l].isEnabled)

        // type in the same password into `Repeat password` field
        app.secureTextFields["RepeatPassword".l].writeText("123")

        // there should be no password errors
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(app.buttons["Create".l].isEnabled)

        // enter other data
        app.textFields["Username".l].writeText("GutHib")
        app.textFields["Email".l].writeText("guthib@gmail.com")
        app.datePickers.firstMatch.tap()
        app.staticTexts["25"].tap()
        app.staticTexts["BirthDate".l]
            .coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.writeText("My GitHub account!")

        // there should be a message when there are no attached files
        XCTAssert(app.staticTexts["FileListEmpty".l].exists)

        // attach a file
        app.buttons["AttachFile".l].tap()
        app.collectionViews["File View"].staticTexts["⁦﻿ ⁨main.dba⁩⁩"].tap()

        // it should appear in the list
        XCTAssert(app.staticTexts["main.dba".l].exists)
        XCTAssert(!app.staticTexts["FileListEmpty".l].exists)

        // delete it
        app.textViews.firstMatch.swipeUp()
        app.staticTexts["main.dba"].swipeLeft()
        app.buttons["DetachFile".l("main.dba")].tap()

        // it should be gone from the list
        XCTAssert(!app.staticTexts["main.dba".l].exists)
        XCTAssert(app.staticTexts["FileListEmpty".l].exists)

        // add it again
        app.buttons["AttachFile".l].tap()
        app.collectionViews["File View"].staticTexts["⁦﻿ ⁨main.dba⁩⁩"].tap()

        // and again
        app.buttons["AttachFile".l].tap()
        app.collectionViews["File View"].staticTexts["⁦﻿ ⁨main.dba⁩⁩"].tap()

        // a confirmation dialog should appear
        XCTAssert(app.staticTexts["ReplaceAttachMsg".l].exists)

        // choose Replace
        app.buttons["Replace"].tap()

        // tap Create button
        app.buttons["Create".l].tap()

        // the Create account form should be hidden
        XCTAssert(!app.textFields["AccountName".l].exists)

        // the account should appear in the list
        XCTAssert(app.staticTexts["github"].exists)

        // and all the data should be correct
        app.staticTexts["github"].tap()
        XCTAssert(app.navigationBars["github"].exists)
        XCTAssert(app.staticTexts["GutHib"].exists)
        XCTAssert(app.staticTexts["guthib@gmail.com"].exists)
        app.staticTexts["Password".l].tap()
        XCTAssert(app.staticTexts["123"].exists)
        XCTAssert(app.staticTexts["25.01.2000"].exists)
        app.staticTexts["Notes".l].tap()
        XCTAssert(app.staticTexts["My GitHub account!"].exists)
        XCTAssert(app.buttons["main.dba".l].exists)
    }
}
