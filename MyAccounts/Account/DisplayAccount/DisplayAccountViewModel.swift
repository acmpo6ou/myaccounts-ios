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
import KeychainAccess

class DisplayAccountViewModel: ObservableObject, ErrorModel {
    var account: Account!
    @Published var showSuccess = false
    @Published var showExportFile = false
    @Published var defaultFilename: String?
    @Published var document: BinaryDocument?

    var logCategory = "display_account"
    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""

    func exportFile(_ fileName: String) {
        do {
            try document = BinaryDocument(account.attachedFiles[fileName])
        } catch {
            showError(error, title: "Error.Export".l)
            return
        }
        self.defaultFilename = fileName
        showExportFile = true
    }

    func handleExportResult(_ result: Result<URL, Error>) {
        switch result {
        case .success:
            showSuccess = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .failure(let error):
            showError(error, title: "Error.Export".l)
        }
    }

    func copyPass() {
        let keychainGroupName = Bundle.main.infoDictionary!["KeychainGroupName"] as! String
        let keychain = Keychain(
            service: "com.acmpo6ou.myaccounts",
            accessGroup: keychainGroupName
        )
        keychain["clipboard"] = account.password
        showSuccess = true
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        // TODO: clear password after 1 minute!!!
    }

    func copyNotes() {
        // TODO: implement
    }
}
