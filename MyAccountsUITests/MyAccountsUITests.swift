//
//  MyAccountsUITests.swift
//  MyAccountsUITests
//
//  Created by Catalyst on 28/06/2023.
//

import XCTest
@testable import MyAccounts

final class MyAccountsUITests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
    }
}
