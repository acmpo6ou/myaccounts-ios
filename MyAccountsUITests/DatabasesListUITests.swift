//
//  DatabasesListUITests.swift
//  DatabasesListUITests
//
//  Created by Catalyst on 28/06/2023.
//

import XCTest
@testable import MyAccounts

final class DatabasesListUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launchArguments = ["testMode"]
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testDelete() throws {
        // try to delete `main`
        app.staticTexts["main"].swipeLeft()
        app.buttons["A11y.DeleteDatabase".l("main")].tap()

        // a confirmation dialog should appear
        let message = "DeleteDatabaseAlert.Message".l("main")
        XCTAssert(app.staticTexts[message].exists)

        // choose Cancel
        app.buttons["Cancel"].tap()

        // `main` should still be in the list
        XCTAssert(app.staticTexts["main"].exists)

        // try deleting it again, choosing Delete this time
        app.staticTexts["main"].swipeLeft()
        app.buttons["A11y.DeleteDatabase".l("main")].tap()
        app.buttons["Delete".l].tap()

        // `main` should be removed from the list
        XCTAssert(!app.staticTexts["main"].exists)
    }
}
