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

class OpenDatabaseViewModel: ObservableObject, ErrorModel {
    var dbViewModel: DatabasesListViewModel?

    let logCategory = "open_database_model"
    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""

    @Published var password = ""
    @Published var passwordError = ""

    func openDatabase(_ database: Binding<Database>) {
        do {
            try database.wrappedValue.open(with: password)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } catch DecodingError.dataCorrupted {
            passwordError = "BadPass".l
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } catch {
            showError(error, title: "Error.OpenDB".l)
        }
    }
}
