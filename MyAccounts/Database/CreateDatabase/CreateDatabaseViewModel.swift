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

class CreateDatabaseViewModel: CreateViewModel, ErrorModel {
    var dbsViewModel: DatabasesListViewModel?
    @Published var showGenPass = false

    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    var logCategory = "create_database_model"

    func createDatabase() {
        let database = Database(name: name, password: password)
        do {
            try database.create()
        } catch {
            showError(error, title: "Error.CreateDB".l)
            return
        }
        dbsViewModel?.databases.append(database)
        dbsViewModel?.databases.sort { $0.name < $1.name }
        dbsViewModel?.showCreateDatabase = false
    }
}
