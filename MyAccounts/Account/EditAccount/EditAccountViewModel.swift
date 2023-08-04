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
import SwiftUI

class EditAccountViewModel: CreateAccountViewModel {
    @Published var showDetachConfirm = false

    func initialize(account: Account, database: Binding<Database>) {
        logCategory = "edit_account_model"
        self.account = account
        self.database = database
        loadFields()
    }

    func loadFields() {
        name = account.accountName
        username = account.username
        email = account.email
        password = account.password
        repeatPassword = account.password
        notes = account.notes

        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        if let date = formater.date(from: account.birthDate) {
            birthDate = date
        }

        for file in account.attachedFiles.keys {
            // URLs that have "https://" as path mean the file they represent is already attached
            attachedFiles[file] = URL(string: "https://")
        }
    }

    override func willDetachFile(_ fileName: String) {
        fileToDetach = fileName
        showDetachConfirm = true
    }

    override func validateName(takenNames: [String]) -> Bool {
        // it's OK if account name didn't change when editing
        super.validateName(
            takenNames: takenNames.filter { $0 != account.accountName }
        )
    }
}
