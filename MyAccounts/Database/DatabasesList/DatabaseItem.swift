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

struct DatabaseItem: View {
    @Binding var database: Database
    @EnvironmentObject var viewModel: DatabasesListViewModel

    var body: some View {
        ListItemView<Database>(
            item: $database,
            deleteLabel: "DeleteDB",
            image: AnyView(
                Image(systemName: database.isOpen ? "lock.open.fill" : "lock.fill")
            )
        )
        .swipeActions {
            if database.isOpen {
                Button(
                    action: { viewModel.editItem($database) },
                    label: { Image(systemName: "pencil") }
                )
                .accessibilityLabel("EditDB".l(database.name))
                .tint(.accentColor)
                Button(
                    action: { viewModel.confirmClose(of: $database) },
                    label: { Image(systemName: "lock.fill") }
                )
                .accessibilityLabel("CloseDB".l(database.name))
            }
        }
    }
}

struct DatabaseItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DatabaseItem(
                database: .constant(Database(name: "closed"))
            )
            DatabaseItem(
                database: .constant(Database(name: "opened", password: "123"))
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
