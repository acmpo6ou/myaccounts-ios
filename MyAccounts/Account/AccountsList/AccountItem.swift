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
import SVGView

struct AccountItem: View {
    @EnvironmentObject var viewModel: AccountsListViewModel
    @Binding var account: Account

    var body: some View {
        ListItemView<Account>(
            item: $account,
            deleteLabel: "DeleteAcc",
            image: account.getIcon()
        )
        .swipeActions {
            Button(
                action: { viewModel.editItem($account) },
                label: { Image(systemName: "pencil") }
            )
            .accessibilityLabel("EditAcc".l(account.accountName))
            .tint(.accentColor)
        }
    }
}

struct AccountItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            AccountItem(account: .constant(testAccount))
                .environmentObject(
                    AccountsListViewModel(
                        .constant(Database(name: "main"))
                    )
                )
        }
        .previewLayout(.sizeThatFits)
    }
}
