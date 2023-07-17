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

open class CreateViewModel: ObservableObject {
    @Published var name = ""
    @Published var password = ""
    @Published var repeatPassword = ""

    @Published var nameError = ""
    @Published var passwordError = ""

    /// Validates name field, displaying error tip if database name is invalid.
    ///
    /// Possible problems with database name:
    ///   - name field is empty
    ///   - name field contains name that is already taken
    ///
    /// - Note: for `EditDatabase` and `EditAccount`
    ///  it's OK if database name hasn't changed throughout editing, and they should pass in correct `takenNames` list.
    /// - Returns: true if name is valid.
    func validateName(takenNames: [String]) -> Bool {
        nameError = name.isEmpty ? "Error.EmptyName".l : ""
        if !nameError.isEmpty { return false }
        nameError = takenNames.contains(name) ? "Error.NameTaken".l : ""
        if !nameError.isEmpty { return false }
        return true
    }
}
