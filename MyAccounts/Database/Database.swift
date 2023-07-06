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
import CommonCrypto

struct Database {
    static let srcDir = ""  // TODO: get actual path

    var name: String
    var password: String?
    var accounts: Accounts = [:]

    var dbaPath: String { "\(Database.srcDir)/\(name).dba" }
    var isOpen: Bool { password == nil }
    var isSaved: Bool {
        // TODO: implement, document
        true
    }

    mutating func open(password: String) throws {
        guard let file = FileHandle(forReadingAtPath: dbaPath) else {
            throw FileError.fileError(message: "Couldn't open \(dbaPath) file for reading.")
        }
        self.password = password
        let salt = try file.read(upToCount: 16)
        let token = try file.readToEnd()
        try? file.close()
        // TODO: decrypt token and deserialize data
    }

    mutating func close() {
        self.password = nil
        self.accounts = [:]
    }

    func create() throws {
        guard let file = FileHandle(forWritingAtPath: dbaPath) else {
            throw FileError.fileError(message: "Couldn't open \(dbaPath) file for writing.")
        }
        let salt = Data.secureRandom(ofSize: 16)
        try file.write(contentsOf: salt)
        // TODO: serialize `accounts`, encrypt them, and write to file
    }

    mutating func rename(newName: String) throws {
        let oldPath = dbaPath
        name = newName
        try FileManager.default.moveItem(atPath: oldPath, toPath: dbaPath)
    }

    func save(name: String, password: String, accounts: Accounts) throws -> Database {
        try FileManager.default.removeItem(atPath: dbaPath)
        let db = Database(name: name, password: password, accounts: accounts)
        try db.create()
        return db
    }

    func encrypt(data: Data, password: String, salt: Data) -> String? {
        guard let key = pbkdf2(password: password, saltData: salt) else { return nil }
        let version: [UInt8] = [0x80]
        let timestamp: [UInt8] = {
            let timestamp = Int(Date().timeIntervalSince1970).bigEndian
            return withUnsafeBytes(of: timestamp, Array.init)
         }()
        let iv = Data.secureRandom(ofSize: kCCBlockSizeAES128)
        let ciphertext = encryptFernet(data: data, key: key, iv: iv)
        let hmac = computeHMAC(version + timestamp + iv + ciphertext, using: key)
        return (version + timestamp + iv + ciphertext + hmac).base64EncodedString()
    }

    func decrypt(fernetToken: Data, password: String, salt: Data) -> Data? {
        guard let key = pbkdf2(password: password, saltData: salt) else { return nil }
        var iv = fernetToken[9 ..< 25]
        let ciphertext = fernetToken[25 ..< fernetToken.count - 32]
        return decryptFernet(ciphertext: ciphertext, key: key, iv: iv)
    }
}

typealias Accounts = [String: Account]

enum FileError: Error {
case fileError(message: String)
}
