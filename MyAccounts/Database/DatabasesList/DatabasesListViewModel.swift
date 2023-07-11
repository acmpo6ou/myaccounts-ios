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

class DatabasesListViewModel: ObservableObject {
    @Published var databases: [Database] = []

    // TODO: is it possible to have this as a computed property?
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    @Published var showDeleteAlert = false
    @Published var deleteMessage = ""
    var deleteIndexes = IndexSet()

    /// Initializes `databases` with all .dba files residing in source directory.
    func loadDatabases() {
        guard let enumerator = FileManager.default.enumerator(atPath: Database.srcDir) else { return }
        var databases: [Database] = []
        while let file = enumerator.nextObject() as? String {
            if file.hasSuffix(".dba") {
                let name = (file as NSString).deletingPathExtension
                databases.append(Database(name: name))
            }
        }
        self.databases = databases.sorted { $0.name < $1.name }
    }

    /// Displays a confirmation dialog to delete selected databases.
    func confirmDelete(at indexes: IndexSet) {
        deleteIndexes = indexes
        deleteMessage = deleteIndexes.map { databases[$0] }
            .map { $0.name }
            .joined(separator: ", ")
        showDeleteAlert = true
    }

    /// Deletes all selected databases.
    ///
    /// Displays an error message listing all databases it failed to delete.
    func deleteDatabases() {
        // TODO: test if it shows correct alert when failed to delete multiple databases
        var errorDbs: [String] = []
        deleteIndexes.forEach {
            do {
                let db = databases[$0]
                try FileManager.default.removeItem(atPath: db.dbaPath)
                databases.removeAll { $0 == db }
            } catch {
                error.log(category: "delete_database")
                errorDbs.append(databases[$0].name)
            }
        }
        errorMessage = errorDbs.joined(separator: ", ")
        showErrorAlert = true
    }
}
