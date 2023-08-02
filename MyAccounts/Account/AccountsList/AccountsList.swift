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

import SwiftUI

struct AccountsList: View {
    @EnvironmentObject var viewModel: AccountsListViewModel
    @Binding var database: Database

    var body: some View {
        ItemsList<Account>(
            createLabel: "CreateAcc".l,
            destination: { AnyView(DisplayAccount(account: $0.wrappedValue)) },
            itemView: { AnyView(AccountItem(account: $0)) },
            createItem: {
                AnyView(
                    ScrollView(.vertical) {
                        CreateAccount(database: $database)
                    }
                )
            },
            editItem: { AnyView(EditAccount(account: $0)) }
        )
        .navigationTitle(database.name)
    }
}

struct AccountsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountsList(database: .constant(Database(name: "main")))
        }
    }
}
