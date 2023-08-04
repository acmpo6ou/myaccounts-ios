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

final class EditAccountUITests: BaseTest {

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["test"].tap()
        app.staticTexts["gmail"].swipeLeft()
        app.buttons["EditAcc".l("gmail")].tap()
    }

    func testEditAccount() throws {
        // all data should be prefilled
        XCTAssertEqual(app.textFields["AccName".l].value as! String, "gmail")
        XCTAssertEqual(app.textFields["Username".l].value as! String, "Gmail User")
        XCTAssertEqual(app.textFields["Email".l].value as! String, "example@gmail.com")
        app.buttons["TogglePass".l("Password".l)].tap()
        app.buttons["TogglePass".l("RepeatPass".l)].tap()
        XCTAssertEqual(app.textFields["Password".l].value as! String, "123")
        XCTAssertEqual(app.textFields["RepeatPass".l].value as! String, "123")
        XCTAssertEqual(app.textViews.firstMatch.value as! String, "My gmail account.")
        XCTAssert(app.staticTexts["file1"].exists)
        XCTAssert(app.staticTexts["file2"].exists)

        // there should be no errors
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(app.buttons["Save".l].isEnabled)

        // MARK: Name field

        // enter a taken name into Account name field
        app.textFields["AccName".l].replaceText(with: "mega")

        // name taken error should appear
        XCTAssert(app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.buttons["Save".l].isEnabled)

        // clear name field
        app.textFields["AccName".l].clearText()

        // empty name error should appear
        XCTAssert(app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.buttons["Save".l].isEnabled)

        // enter a valid name
        app.textFields["AccName".l].writeText("github")

        // there should be no name errors
        XCTAssert(!app.staticTexts["Error.NameTaken".l].exists)
        XCTAssert(!app.staticTexts["Error.EmptyName".l].exists)
        XCTAssert(app.buttons["Save".l].isEnabled)

        // MARK: Password fields

        // clear password field
        app.textFields["Password".l].clearText()

        // an error should appear
        XCTAssert(app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.buttons["Save".l].isEnabled)

        // enter a new password
        app.textFields["Password".l].replaceText(with: "passw0rd!")

        // passwords diff error should appear
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(!app.buttons["Save".l].isEnabled)

        // type in the same password into `Repeat password` field
        app.textFields["RepeatPass".l].replaceText(with: "passw0rd!")

        // there should be no errors
        XCTAssert(!app.staticTexts["Error.EmptyPass".l].exists)
        XCTAssert(!app.staticTexts["Error.PassDiff".l].exists)
        XCTAssert(app.buttons["Save".l].isEnabled)

        // MARK: Other fields

        // change other fields
        app.textFields["Username".l].replaceText(with: "GutHib")
        app.textFields["Email".l].writeText("my")
        app.datePickers.firstMatch.tap()
        app.staticTexts["14"].tap()
        app.buttons["PopoverDismissRegion"].tap()
        app.textViews.firstMatch.writeText("Hello ")

        // attach a file
        app.buttons["AttachFile".l].tap()
        app.collectionViews["File View"].staticTexts["⁦﻿ ⁨main.dba⁩⁩"].tap()

        // it should appear in the list
        XCTAssert(app.staticTexts["main.dba".l].exists)
        XCTAssert(app.staticTexts["file1".l].exists)
        XCTAssert(app.staticTexts["file2".l].exists)

        // detach a file
        app.textViews.firstMatch.swipeUp()
        app.staticTexts["file1"].swipeLeft()
        app.buttons["DetachFile".l("file1")].tap()

        // a confirmation dialog should appear
        XCTAssert(app.staticTexts["DetachFileMsg".l].exists)

        // choose Detach
        app.buttons["Detach".l].tap()

        // the file should be removed
        XCTAssert(app.staticTexts["main.dba".l].exists)
        XCTAssert(!app.staticTexts["file1".l].exists)
        XCTAssert(app.staticTexts["file2".l].exists)

        // Save the changes
        app.buttons["Save".l].tap()

        // the account should appear in the list
        XCTAssert(app.staticTexts["github"].exists)
        XCTAssert(!app.staticTexts["gmail"].exists)

        // and all its data should be correct
        app.staticTexts["github"].tap()
        XCTAssert(app.navigationBars["github"].exists)
        XCTAssert(app.staticTexts["GutHib"].exists)
        XCTAssert(app.staticTexts["example@gmailmy.com"].exists)
        app.staticTexts["Password".l].tap()
        XCTAssert(app.staticTexts["passw0rd!"].exists)
        XCTAssert(app.staticTexts["14.01.2000"].exists)
        app.staticTexts["Notes".l].tap()
        XCTAssert(app.staticTexts["Hello My gmail account."].exists)
        XCTAssert(app.buttons["main.dba".l].exists)
        XCTAssert(app.buttons["file2".l].exists)
        XCTAssert(!app.buttons["file1".l].exists)
    }
}
