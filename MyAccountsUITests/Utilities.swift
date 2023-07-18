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

import Foundation
import os
import XCTest

extension String {
    var l: String {
        return NSLocalizedString(
            self,
            bundle: Bundle(for: DatabasesListUITests.self),
            comment: ""
        )
    }
    func l(_ arguments: CVarArg...) -> String {
        return String(format: self.l, arguments: arguments)
    }
}

extension Data {
    var utf8: String? {
        String(data: self, encoding: .utf8)
    }
}

extension Error {
    func log(category: String) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: category)
        logger.error("\(self.localizedDescription)")
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        // workaround for apple bug
        if let placeholderString = self.placeholderValue, placeholderString == stringValue {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        tap()
        typeText(deleteString)
    }

    func writeText(_ text: String) {
        tap()
        typeText(text)
    }

    func replaceText(with newText: String) {
        clearText()
        writeText(newText)
    }
}
