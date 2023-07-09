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
@testable import MyAccounts

let account = Account(
    accountName: "gmail",
    username: "Gmail User",
    email: "example@gmail.com",
    password: "123",
    birthDate: "01.01.2000",
    notes: "My gmail account.",
    attachedFiles: ["file1": "ZmlsZTEgY29udGVudAo=", "file2": "ZmlsZTIgY29udGVudAo="]
)

let account2 = Account(
    accountName: "mega",
    username: "Mega User",
    email: "example@gmail.com",
    password: "312",
    birthDate: "05.01.2000",
    notes: "My mega account."
)

let accounts = [
    account.accountName: account,
    account2.accountName: account2
]
