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

class EditDatabaseViewModel: CreateDatabaseViewModel {
    var database: Binding<Database>?

    func initialize(_ database: Binding<Database>) {
        logCategory = "edit_database_model"
        self.database = database
        let db = database.wrappedValue
        name = db.name
        password = db.password ?? ""
        repeatPassword = db.password ?? ""
    }

    override func validateName(takenNames: [String]) -> Bool {
        // it's OK if database name didn't change when editing
        super.validateName(
            takenNames: takenNames.filter { $0 != database?.wrappedValue.name }
        )
    }

    override func createDatabase() {
        do {
            try database?.wrappedValue.save(name: name, password: password)
        } catch {
            showError(error, title: "Error.EditDB".l)
            return
        }
        dbsViewModel?.databases.sort { $0.name < $1.name }
        dbsViewModel?.showEditDatabase = false
    }
}
