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

struct Database: Codable {
    var name: String
    var password: String?
    var accounts: [String: Account] = [:]

    var dbaPath: String {
        // TODO: construct dba file path from name and SRC_DIR
        ""
    }
    var isOpen: Bool { password == nil }
    var isSaved: Bool {
        // TODO: implement, document
        true
    }

    mutating func open(password: String) throws {
        guard let file = FileHandle(forReadingAtPath: dbaPath) else {
            throw FileError.fileError(message: "Couldn't open \(dbaPath) file.")
        }
        self.password = password
        let salt = try file.read(upToCount: 16)
        let token = try file.readToEnd()
        try? file.close()
        // TODO: decrypt token and deserialize data
    }
}

enum FileError: Error {
case fileError(message: String)
}
