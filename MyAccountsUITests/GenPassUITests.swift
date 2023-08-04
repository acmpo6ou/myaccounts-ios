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

final class GenPassUITests: BaseTest {
    var length = 16

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons["CreateDB".l].tap()

        app.buttons["more"].tap()
        app.buttons["GenPass".l].tap()

        length = Int.random(in: 8...128)
        app.pickerWheels.element.adjust(toPickerWheelValue: "\(length)")
    }

    func testGeneratePasswordAllChars() throws {
        app.buttons["Generate".l].tap()
        let pass1 = app.textFields["Password".l].value as! String
        let pass2 = app.textFields["RepeatPass".l].value as! String

        XCTAssertEqual(pass1, pass2)
        XCTAssertEqual(pass1.count, length)
        XCTAssert(pass1.hasoneof(chars: Chars.numbers))
        XCTAssert(pass1.hasoneof(chars: Chars.lower))
        XCTAssert(pass1.hasoneof(chars: Chars.upper))
        XCTAssert(pass1.hasoneof(chars: Chars.punct))
    }

    func testGeneratePasswordNumbers() throws {
        app.switches["Lower".l].toggle()
        app.switches["Upper".l].toggle()
        app.switches["Punct".l].toggle()
        app.buttons["Generate".l].tap()
        let pass1 = app.textFields["Password".l].value as! String
        let pass2 = app.textFields["RepeatPass".l].value as! String

        XCTAssertEqual(pass1, pass2)
        XCTAssertEqual(pass1.count, length)
        XCTAssert(pass1.hasoneof(chars: Chars.numbers))
        XCTAssert(!pass1.hasoneof(chars: Chars.lower))
        XCTAssert(!pass1.hasoneof(chars: Chars.upper))
        XCTAssert(!pass1.hasoneof(chars: Chars.punct))
    }

    func testGeneratePasswordLower() throws {
        app.switches["Numbers".l].toggle()
        app.switches["Upper".l].toggle()
        app.switches["Punct".l].toggle()
        app.buttons["Generate".l].tap()
        let pass1 = app.textFields["Password".l].value as! String
        let pass2 = app.textFields["RepeatPass".l].value as! String

        XCTAssertEqual(pass1, pass2)
        XCTAssertEqual(pass1.count, length)
        XCTAssert(!pass1.hasoneof(chars: Chars.numbers))
        XCTAssert(pass1.hasoneof(chars: Chars.lower))
        XCTAssert(!pass1.hasoneof(chars: Chars.upper))
        XCTAssert(!pass1.hasoneof(chars: Chars.punct))
    }

    func testGeneratePasswordUpper() throws {
        app.switches["Numbers".l].toggle()
        app.switches["Lower".l].toggle()
        app.switches["Punct".l].toggle()
        app.buttons["Generate".l].tap()
        let pass1 = app.textFields["Password".l].value as! String
        let pass2 = app.textFields["RepeatPass".l].value as! String

        XCTAssertEqual(pass1, pass2)
        XCTAssertEqual(pass1.count, length)
        XCTAssert(!pass1.hasoneof(chars: Chars.numbers))
        XCTAssert(!pass1.hasoneof(chars: Chars.lower))
        XCTAssert(pass1.hasoneof(chars: Chars.upper))
        XCTAssert(!pass1.hasoneof(chars: Chars.punct))
    }

    func testGeneratePasswordPunctuation() throws {
        app.switches["Numbers".l].toggle()
        app.switches["Lower".l].toggle()
        app.switches["Upper".l].toggle()
        app.buttons["Generate".l].tap()
        let pass1 = app.textFields["Password".l].value as! String
        let pass2 = app.textFields["RepeatPass".l].value as! String

        XCTAssertEqual(pass1, pass2)
        XCTAssertEqual(pass1.count, length)
        XCTAssert(!pass1.hasoneof(chars: Chars.numbers))
        XCTAssert(!pass1.hasoneof(chars: Chars.lower))
        XCTAssert(!pass1.hasoneof(chars: Chars.upper))
        XCTAssert(pass1.hasoneof(chars: Chars.punct))
    }
}

struct Chars {
    static let numbers = "0123456789"
    static let lower = "abcdefghijklmnopqrstuvwxyz"
    static let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let punct = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
}

extension String {
    func hasoneof(chars: String) -> Bool {
        let charset = CharacterSet(charactersIn: chars)
        return rangeOfCharacter(from: charset) != nil
    }
}
