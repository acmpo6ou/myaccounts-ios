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
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    @Published var showDeleteAlert = false
    @Published var deleteMessage = ""
    var deleteIndexes = IndexSet()

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

    // TODO: document
    func confirmDelete(at indexes: IndexSet) {
        deleteIndexes = indexes
        deleteMessage = deleteIndexes.map { databases[$0] }
            .map { $0.name }
            .joined(separator: ", ")
        showDeleteAlert = true
    }
    
    // TODO: document
    func deleteDatabases() {
        // TODO: test if it shows correct alert when failed to delete multiple databases
        var errorDbs: [String] = []
        deleteIndexes.forEach {
            do {
                let db = databases[$0]
                try FileManager.default.removeItem(atPath: db.dbaPath)
                databases.removeAll { $0 == db }
            } catch {
                errorDbs.append(databases[$0].name)
            }
        }
        errorMessage = errorDbs.joined(separator: ", ")
        showErrorAlert = true
    }
}
