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

class AccountsListViewModel: ListViewModel<Account> {
    var database: Binding<Database>
    override var items: [Account] {
        get {
            database.wrappedValue.accounts.values
                .sorted { $0.accountName < $1.accountName }
        }
        set {
            fatalError("Don't use this `set`!")
        }
    }

    init(_ database: Binding<Database>) {
        self.database = database
        super.init()
        logCategory = "accounts_view_model"
    }

    override func deleteItem() {
        guard let name = itemToDelete?.accountName else { return }
        database.wrappedValue.accounts[name] = nil
    }
}
