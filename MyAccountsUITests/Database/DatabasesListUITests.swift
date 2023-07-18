//
//  DatabasesListUITests.swift
//  DatabasesListUITests
//
//  Created by Catalyst on 28/06/2023.
//

import XCTest
@testable import MyAccounts

final class DatabasesListUITests: BaseTest {

    func testNoItems() throws {
        // when there are databases, there should be no message
        XCTAssert(!app.staticTexts["NoItems".l].exists)

        // delete all databases
        for db in ["main", "test", "unsaved"] {
            app.staticTexts[db].swipeLeft()
            app.buttons["A11y.DeleteDatabase".l(db)].tap()
            app.buttons["Delete".l].tap()
        }

        // a message saying "No items" should appear
        XCTAssert(app.staticTexts["NoItems".l].exists)
    }

    func testDelete() throws {
        // try to delete `main`
        app.staticTexts["main"].swipeLeft()
        app.buttons["A11y.DeleteDatabase".l("main")].tap()

        // a confirmation dialog should appear
        let message = "DeleteDBAlert.Message".l("main")
        XCTAssert(app.staticTexts[message].exists)

        // choose Delete
        app.buttons["Delete".l].tap()

        // `main` should be removed from the list
        XCTAssert(!app.staticTexts["main"].exists)
    }

    func testClose() throws {
        // `main` is closed, so it SHOULDN'T have a Close button
        app.staticTexts["main"].swipeLeft()
        XCTAssert(!app.buttons["A11y.CloseDatabase".l("main")].exists)

        // `test` is opened, so it SHOULD have a Close button
        app.staticTexts["test"].swipeLeft()
        var closeButton = app.buttons["A11y.CloseDatabase".l("test")]
        XCTAssert(closeButton.exists)

        // once tapped, no dialog should appear since `test` doesn't have unsaved changes
        closeButton.tap()
        var message = "CloseDBAlert.Message".l("test")
        XCTAssert(!app.staticTexts[message].exists)

        // `test` should now be closed, so it shouldn't have Close button anymore
        app.staticTexts["test"].swipeLeft()
        closeButton = app.buttons["A11y.CloseDatabase".l("test")]
        XCTAssert(!closeButton.exists)

        // `unsaved` has unsaved changes, so closing it should show a confirmation dialog
        app.staticTexts["unsaved"].swipeLeft()
        closeButton = app.buttons["A11y.CloseDatabase".l("unsaved")]
        closeButton.tap()
        message = "CloseDBAlert.Message".l("unsaved")
        XCTAssert(app.staticTexts[message].exists)

        // choose Save
        app.buttons["CloseDBAlert.Save".l].tap()

        // `unsaved` should be closed now
        app.staticTexts["unsaved"].swipeLeft()
        closeButton = app.buttons["A11y.CloseDatabase".l("unsaved")]
        XCTAssert(!closeButton.exists)

        // TODO: test that it was actually saved by opening it and checking list of accounts
        // TODO: test choosing Close instead of Save
    }

    func testNavDestination() throws {
        // a closed database should navigate to OpenDatabase
        app.staticTexts["main"].tap()
        XCTAssert(app.navigationBars["OpenDB".l("main")].exists)

        // an opened database should navigate to AccountsList
        goBack()
        app.staticTexts["test"].tap()
        XCTAssert(app.navigationBars["test"].exists)

        // close `test`
        goBack()
        app.staticTexts["test"].swipeLeft()
        app.buttons["A11y.CloseDatabase".l("test")].tap()

        // it should now go to OpenDatabase
        app.staticTexts["test"].tap()
        XCTAssert(app.navigationBars["OpenDB".l("test")].exists)
    }

    func testEditButton() throws {
        // `main` is closed, so it SHOULDN'T have an Edit button
        app.staticTexts["main"].swipeLeft()
        XCTAssert(!app.buttons["A11y.EditDatabase".l("main")].exists)

        // `test` is opened, so it SHOULDN have an Edit button
        app.staticTexts["test"].swipeLeft()
        XCTAssert(app.buttons["A11y.EditDatabase".l("test")].exists)
    }
}
