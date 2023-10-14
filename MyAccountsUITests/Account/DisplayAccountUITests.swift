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

final class DisplayAccountUITests: BaseTest {

    func testAccountInfo() throws {
        // go to `gmail` info screen
        app.staticTexts["test"].tap()
        app.staticTexts["gmail"].tap()

        // all info should be correct
        XCTAssert(app.navigationBars["gmail"].exists)
        XCTAssert(app.staticTexts["Gmail User"].exists)
        XCTAssert(app.staticTexts["example@gmail.com"].exists)
        XCTAssert(app.staticTexts["01.01.2000"].exists)

        // password and notes should be hidden
        XCTAssert(!app.staticTexts["123"].exists)
        XCTAssert(!app.staticTexts["My gmail account."].exists)

        // there should be some attached files
        XCTAssert(app.staticTexts["ATTACHED FILES"].exists)
        XCTAssert(app.buttons["file1"].exists)
        XCTAssert(app.buttons["file2"].exists)

        // expanding password and notes should reveal them
        app.staticTexts["Password".l].tap()
        XCTAssert(app.staticTexts["123"].exists)
        app.staticTexts["Notes".l].tap()
        XCTAssert(app.staticTexts["My gmail account."].exists)
    }

    func testAttachedFiles() {
        // "attached files" section should be hidden when there are no attached files
        app.staticTexts["unsaved"].tap()
        app.staticTexts["mega"].tap()
        XCTAssert(!app.staticTexts["ATTACHED FILES"].exists)

        // go back, then go to `gmail` info screen of `no_attached` database
        goBack()
        goBack()
        app.staticTexts["no_attached"].tap()
        app.staticTexts["gmail"].tap()

        // export `file1` replacing if it already exists
        app.buttons["file1"].tap()
        app.buttons["Move"].tap()

        // Success message should appear
        XCTAssert(app.staticTexts["Success".l].exists)

        // try exporting a corrupted file
        app.buttons["file2"].tap()

        // Error message should appear
        XCTAssert(app.staticTexts["Error.Export".l].exists)
    }
}
