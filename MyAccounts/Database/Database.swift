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

class Database: Equatable {
    static var srcDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/src/"
    let filemgr = FileManager.default

    var name: String
    var password: String?
    var accounts: Accounts

    var dbaPath: String { "\(Database.srcDir)/\(name).dba" }
    var isOpen: Bool { password != nil }

    init(name: String, password: String? = nil, accounts: Accounts = [:]) {
        self.name = name
        self.password = password
        self.accounts = accounts
    }

    static func == (lhs: Database, rhs: Database) -> Bool {
        lhs.name == rhs.name &&
        lhs.password == rhs.password &&
        lhs.accounts == rhs.accounts
    }

    /// Whether an in-memory database is the same as the database on disk.
    ///
    /// Used when closing a database to check if it's saved.
    /// If it isn't, a dialog about unsaved changes should be shown.
    var isSaved: Bool {
        guard let password = self.password else { return true }
        let diskDb = Database(name: self.name)
        do {
            try diskDb.open(with: password)
        } catch {
            error.log(category: "database")
            return false
        }
        return self.accounts == diskDb.accounts
    }

    func open(with password: String) throws {
        guard let file = FileHandle(forReadingAtPath: dbaPath) else {
            throw DBError.databaseError("Couldn't open \(dbaPath) file for reading.")
        }
        guard let salt = try file.read(upToCount: 16) else {
            throw DBError.databaseError("Couldn't read salt from \(dbaPath).")
        }
        guard let token = try file.readToEnd() else {
            throw DBError.databaseError("Couldn't read fernet token from \(dbaPath).")
        }
        try? file.close()
        self.password = password
        let json = try decrypt(token, password, salt)
        self.accounts = try JSONDecoder().decode([String: Account].self, from: json)
    }

    func close() {
        self.password = nil
        self.accounts = [:]
    }

    /// Creates the database using current values of `name`, `password`, and `accounts`.
    func create() throws {
        filemgr.createFile(atPath: dbaPath, contents: Data())
        guard let file = FileHandle(forWritingAtPath: dbaPath) else {
            throw DBError.databaseError("\(dbaPath) file was not created.")
        }
        guard let password else {
            throw DBError.databaseError("Can't create a database when password is nil.")
        }

        let salt = try Data.secureRandom(ofSize: 16)
        try file.write(contentsOf: salt)

        let json = try JSONEncoder().encode(accounts)
        let token = try encrypt(json, password, salt)
        guard let data = token.data(using: .utf8) else {
            throw DBError.databaseError("Can't encode fernet token as utf8.")
        }
        try file.write(contentsOf: data)
        try? file.close()
    }

    func rename(to newName: String) throws {
        let oldPath = dbaPath
        name = newName
        try filemgr.moveItem(atPath: oldPath, toPath: dbaPath)
    }

    /// Replaces old database file with a new one, effectively saving changes done to the database.
    func save(name: String, password: String) throws {
        try filemgr.removeItem(atPath: dbaPath)
        self.name = name
        self.password = password
        try create()
    }

    func save() throws {
        try filemgr.removeItem(atPath: dbaPath)
        try create()
    }

    func encrypt(_ data: Data, _ password: String, _ salt: Data) throws -> String {
        guard let key = pbkdf2(password: password, saltData: salt) else {
            throw DBError.databaseError("Couldn't derive key with password \(password)")
        }
        let signingKey = key[0 ..< 16]
        let cryptoKey = key[16 ..< key.count]

        let version: [UInt8] = [0x80]
        let timestamp: [UInt8] = {
            let timestamp = Int(Date().timeIntervalSince1970).bigEndian
            return withUnsafeBytes(of: timestamp, Array.init)
         }()
        let iv = try Data.secureRandom(ofSize: kCCBlockSizeAES128)
        let ciphertext = encryptFernet(data: data, key: cryptoKey, iv: iv)
        let hmac = computeHMAC(version + timestamp + iv + ciphertext, using: signingKey)
        return (version + timestamp + iv + ciphertext + hmac).toBase64Url()
    }

    func decrypt(_ encodedToken: Data, _ password: String, _ salt: Data) throws -> Data {
        guard let key = pbkdf2(password: password, saltData: salt) else {
            throw DBError.databaseError("Couldn't derive key with password \(password)")
        }
        guard let token = encodedToken.utf8 else {
            throw DBError.databaseError("Can't decode fernet token to utf8: \(encodedToken)")
        }
        guard let fernetToken = Data(base64URL: token) else {
            throw DBError.databaseError("Can't decode fernet token from base64: \(token)")
        }
        let cryptoKey = key[16 ..< key.count]
        let iv = fernetToken[9 ..< 25]
        let ciphertext = fernetToken[25 ..< fernetToken.count - 32]
        return decryptFernet(ciphertext: ciphertext, key: cryptoKey, iv: iv)
    }
}

typealias Accounts = [String: Account]

enum DBError: Error {
case databaseError(_ message: String)
}
