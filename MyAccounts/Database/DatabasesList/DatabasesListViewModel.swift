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
    let filemgr = FileManager.default
    @Published var databases: [Database] = []

    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""

    @Published var showDeleteAlert = false
    @Published var deleteMessage = ""
    var dbToDelete: Database?

    @Published var showCloseAlert = false
    @Published var closeMessage = ""
    var closeIndex: Int = 0

    /// Creates the source folder if needed.
    func fixSrcFolder() {
        do {
            try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: true)
        } catch {
            log(error)
        }
    }

    /// Initializes `databases` with all .dba files residing in source directory.
    func loadDatabases() {
        print("SRC_DIR: \(Database.srcDir)")
        guard let enumerator = filemgr.enumerator(atPath: Database.srcDir) else { return }
        var databases: [Database] = []
        while let file = enumerator.nextObject() as? String {
            if file.hasSuffix(".dba") {
                let name = (file as NSString).deletingPathExtension
                databases.append(Database(name: name))
            }
        }
        self.databases = databases.sorted { $0.name < $1.name }
    }

    /// Displays a confirmation dialog to delete selected database.
    func confirmDelete(of database: Database) {
        dbToDelete = database
        deleteMessage = "DeleteDatabaseAlert.Message".l(database.name)
        showDeleteAlert = true
    }

    func deleteDatabase() {
        do {
            try filemgr.removeItem(atPath: dbToDelete!.dbaPath)
            databases.removeAll { $0 == dbToDelete }
        } catch {
            showError(error, title: "Error.DatabaseDeletion".l)
        }
    }

    func confirmClose(of database: Database) {
        closeIndex = databases.firstIndex(of: database) ?? 0
        if database.isSaved {
            closeDatabase()
            return
        }
        closeMessage = "CloseDatabaseAlert.Message".l(database.name)
        showCloseAlert = true
    }

    func closeDatabase() {
        databases[closeIndex].close()
    }

    func saveDatabase() {
        g
    }

    func showError(_ error: Error, title: String) {
        log(error)
        errorTitle = title
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }

    func log(_ error: Error) {
        error.log(category: "database_view_model")
    }
}
