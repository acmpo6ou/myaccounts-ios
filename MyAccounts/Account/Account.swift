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

struct Account: ListItem, Codable, Equatable {
    let accountName: String
    let username: String
    let email: String
    let password: String
    let birthDate: String
    let notes: String
    var attachedFiles: [String: String] = [:]
    var itemName: String { accountName }

    enum CodingKeys: String, CodingKey {
        case accountName = "account"
        case username = "name"
        case email = "email"
        case password = "password"
        case birthDate = "date"
        case notes = "comment"
        case attachedFiles = "attach_files"
    }
}

let testAccount = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "123",
    birthDate: "01.01.2000",
    notes: "My gmail account.",
    attachedFiles: ["file1": "ZmlsZTEgY29udGVudAo=", "file2": "ZmlsZTIgY29udGVudAo="]
)

let longAccount = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "123",
    birthDate: "01.01.2000",
    notes: String(repeating: "My gmail account.", count: 32),
    attachedFiles: ["file1": "ZmlsZTEgY29udGVudAo=", "file2": "ZmlsZTIgY29udGVudAo="]
)

let accountUnattached = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "123",
    birthDate: "01.01.2000",
    notes: "My gmail account."
)
