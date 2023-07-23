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

final class AccountsListUITests: BaseTest {

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["test"].tap()
    }

    func testDelete() throws {
        // try to delete `gmail`
        app.staticTexts["gmail"].swipeLeft()
        app.buttons["DeleteAcc".l("gmail")].tap()

        // a confirmation dialog should appear
        let message = "DeleteItemAlert.Message".l("gmail")
        XCTAssert(app.staticTexts[message].exists)

        // choose Delete
        app.buttons["Delete".l].tap()

        // `gmail` should be removed from the list
        XCTAssert(!app.staticTexts["gmail"].exists)
    }
}
