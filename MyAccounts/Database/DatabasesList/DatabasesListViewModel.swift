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

    @Published var showDeleteAlert = false
    @Published var deleteMessage = ""
    var deleteIndexes = IndexSet()

    func loadDatabases() {
        guard let enumerator = FileManager.default.enumerator(atPath: Database.srcDir) else { return }
        var databases: [Database] = []
        while let file = enumerator.nextObject() as? String {
            if file.hasSuffix(".txt") {
                let name = (file as NSString).deletingPathExtension
                databases.append(Database(name: name))
            }
        }
        self.databases = databases.sorted { $0.name < $1.name }
    }

    func confirmDelete(at indexes: IndexSet) {
        deleteIndexes = indexes
        deleteMessage = deleteIndexes.map { databases[$0] }
            .map { $0.name }
            .joined(separator: ", ")
        showDeleteAlert = true
    }
    
    func deleteDatabases() {
        deleteIndexes.forEach {
            $0 // TODO: delete the databases
        }
    }
}
