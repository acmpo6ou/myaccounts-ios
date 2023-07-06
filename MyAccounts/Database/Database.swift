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
    static let srcDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path

    var name: String
    var password: String?
    var accounts: Accounts = [:]

    var dbaPath: String { "\(Database.srcDir)/\(name).dba" }
    var isOpen: Bool { password == nil }
    var isSaved: Bool {
        get throws {
            guard let password = self.password else {
                throw DatabaseError.error("Accessing `isSaved` on a closed database is not allowed.")
            }
            var diskDb = Database(name: self.name)
            try diskDb.open(password)
            return self.accounts == diskDb.accounts
        }
    }

    mutating func open(_ password: String) throws {
        guard let file = FileHandle(forReadingAtPath: dbaPath) else {
            throw DatabaseError.error("Couldn't open \(dbaPath) file for reading.")
        }
        guard let salt = try file.read(upToCount: 16) else {
            throw DatabaseError.error("Couldn't read salt from \(dbaPath).")
        }
        guard let token = try file.readToEnd() else {
            throw DatabaseError.error("Couldn't read fernet token from \(dbaPath).")
        }
        try? file.close()
        self.password = password
        let json = try decrypt(token, password, salt)
        self.accounts = try JSONDecoder().decode([String: Account].self, from: json)
    }

    mutating func close() {
        self.password = nil
        self.accounts = [:]
    }

    func create() throws {
        guard let file = FileHandle(forWritingAtPath: dbaPath) else {
            throw DatabaseError.error("Couldn't open \(dbaPath) file for writing.")
        }
        guard let password else {
            throw DatabaseError.error("Can't create a database when password is nil.")
        }

        let salt = Data.secureRandom(ofSize: 16)
        try file.write(contentsOf: salt)

        let json = try JSONEncoder().encode(accounts)
        let token = try encrypt(json, password, salt)
        guard let data = token.data(using: .utf8) else {
            throw DatabaseError.error("Can't encode fernet token as utf8.")
        }
        try file.write(contentsOf: data)
        try? file.close()
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

    func encrypt(_ data: Data, _ password: String, _ salt: Data) throws -> String {
        guard let key = pbkdf2(password: password, saltData: salt) else {
            throw DatabaseError.error("Couldn't derive key with password \(password)")
        }
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

    func decrypt(_ fernetToken: Data, _ password: String, _ salt: Data) throws -> Data {
        guard let key = pbkdf2(password: password, saltData: salt) else {
            throw DatabaseError.error("Couldn't derive key with password \(password)")
        }
        var iv = fernetToken[9 ..< 25]
        let ciphertext = fernetToken[25 ..< fernetToken.count - 32]
        return decryptFernet(ciphertext: ciphertext, key: key, iv: iv)
    }
}

typealias Accounts = [String: Account]

enum DatabaseError: Error {
case error(_ message: String)
}
