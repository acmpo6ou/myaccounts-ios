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

class DatabasesListViewModel: ListViewModel<Database> {
    let filemgr = FileManager.default
    @Published var databases: [Database] = []

    @Published var showCloseAlert = false
    @Published var closeMessage = ""
    var dbToClose: Binding<Database>?

    override init() {
        super.init()
        logCategory = "database_view_model"
    }

    /// Creates the source folder if needed.
    func fixSrcFolder() {
        do {
            try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: true)
        } catch {
            log(error)
        }
    }

    /// Initializes `databases` with all .dba files residing in source directory.
    ///
    /// Can be used to refresh `databases`.
    func loadDatabases() {
        print("SRC_DIR: \(Database.srcDir)")
        guard let enumerator = filemgr.enumerator(atPath: Database.srcDir) else { return }
        let dbNames = databases.map { $0.name }
        while let file = enumerator.nextObject() as? String {
            let name = (file as NSString).deletingPathExtension
            // add only databases that are missing from the list
            // don't replace the whole list of dbs, as this will close all open databases.
            if file.hasSuffix(".dba") && !dbNames.contains(name) {
                databases.append(Database(name: name))
            }
        }
        databases.sort { $0.name < $1.name }
    }

    func deleteDatabase() {
        do {
            try filemgr.removeItem(atPath: itemToDelete!.dbaPath)
            databases.removeAll { $0 == itemToDelete }
        } catch {
            showError(error, title: "Error.DeleteDatabase".l)
        }
    }

    /// Displays a confirmation dialog to close/save selected database.
    ///
    /// - Note: The dialog is shown only if the database has unsaved changes.
    func confirmClose(of database: Binding<Database>) {
        dbToClose = database
        if database.wrappedValue.isSaved {
            closeDatabase()
            return
        }
        closeMessage = "CloseDBAlert.Message".l(database.wrappedValue.name)
        showCloseAlert = true
    }

    func closeDatabase() {
        dbToClose?.wrappedValue.close()
    }

    func saveDatabase() {
        do {
            try dbToClose?.wrappedValue.save()
            closeDatabase()
        } catch {
            showError(error, title: "Error.CloseDatabase".l)
        }
    }
}
