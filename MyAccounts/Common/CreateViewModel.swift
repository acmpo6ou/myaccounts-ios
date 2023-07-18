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
    @Published var applyEnabled = false

    let allowedChars = "abcdefghijklmnopqrstuvwxyz" +
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        "0123456789.()-_"

    /// Cleans the database name.
    ///
    /// Database names are used to name their .dba files, so they should contain only allowed characters.
    func cleanDBName() {
        name = name.filter(allowedChars.contains)
    }

    /// Validates name field, displaying error tip if database name is invalid.
    ///
    /// Possible problems with database name:
    ///   - name field is empty
    ///   - name field contains name that is already taken
    ///
    /// - Note: for `EditDatabase` and `EditAccount`
    ///  it's OK if database name hasn't changed throughout editing, and they should pass in correct `takenNames` list.
    /// - Returns: `true` if name is valid.
    func validateName(takenNames: [String]) -> Bool {
        nameError = name.isEmpty ? "Error.EmptyName".l : ""
        if !nameError.isEmpty { return false }
        nameError = takenNames.contains(name) ? "Error.NameTaken".l : ""
        if !nameError.isEmpty { return false }
        return true
    }

    /// Validates password fields, displaying error tips if passwords are invalid.
    ///
    /// Possible problems with passwords:
    ///   - password fields are empty
    ///   - passwords from password fields don't match
    /// - Returns: `true` if passwords are valid.
    func validatePasswords() -> Bool {
        passwordError = password.isEmpty ? "Error.EmptyPass".l : ""
        if !passwordError.isEmpty { return false }
        passwordError = password != repeatPassword ? "Error.PassDiff".l : ""
        if !passwordError.isEmpty { return false }
        return true
    }

    /// Enables or disables apply button depending on whether there are errors in the form.
    ///
    /// - Note: "apply button" is a general way to refer to "Create" or "Edit" button.
    func applyEnabled(takenNames: [String]) {
        let nameGood = validateName(takenNames: takenNames)
        let passwordsGood = validatePasswords()
        applyEnabled = nameGood && passwordsGood
    }
}
