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

struct ListItemView<T: ListItem>: View {
    @EnvironmentObject var viewModel: ListViewModel<T>
    @Binding var item: T
    var deleteLabel: String
    var image: AnyView

    var body: some View {
        HStack {
            image.frame(width: 32, height: 32)
            Text(item.itemName)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .font(.title)
        .transition(.slide)
        .swipeActions {
            Button(
                action: { viewModel.confirmDelete(of: item) },
                label: { Image(systemName: "trash.fill") }
            )
            .accessibilityLabel(deleteLabel.l(item.itemName))
            .tint(.red)
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    struct TestItem: ListItem {
        var itemName = "item"
    }

    static var previews: some View {
        List {
            ListItemView(
                item: .constant(TestItem()),
                deleteLabel: "Delete %@",
                image: AnyView(Image(systemName: "photo"))
            )
        }
    }
}
