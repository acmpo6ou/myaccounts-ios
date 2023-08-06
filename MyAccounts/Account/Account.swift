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

import SwiftUI
import SVGView

let docsPath = Bundle.main.resourcePath!
let icons = (try? FileManager.default
    .contentsOfDirectory(atPath: docsPath)
    .filter { $0.hasSuffix(".txt") }
    .map { String($0.dropLast(".txt".count)) }
    .sorted { $0.count > $1.count }) ?? []

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

    func getIcon() -> AnyView {
        var icon = "default-icon"
        for name in icons where accountName.contains(name) {
            icon = name
            break
        }

        if let path = Bundle.main.url(forResource: icon, withExtension: "txt") {
            return AnyView(SVGView(contentsOf: path))
        } else {
            return AnyView(Image(systemName: "person.crop.circle"))
        }
    }
}

let testAccount = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "c$$*.Fg({qU'wlJ6",
    birthDate: "01.01.2000",
    notes: "My gmail account.",
    attachedFiles: ["file1": "ZmlsZTEgY29udGVudAo=", "file2": "ZmlsZTIgY29udGVudAo="]
)

let longAccount = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "c$$*.Fg({qU'wlJ6",
    birthDate: "01.01.2000",
    notes: String(repeating: "My gmail account.", count: 32),
    attachedFiles: ["file1": "ZmlsZTEgY29udGVudAo=", "file2": "ZmlsZTIgY29udGVudAo="]
)

let accountUnattached = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "c$$*.Fg({qU'wlJ6",
    birthDate: "01.01.2000",
    notes: "My gmail account."
)
