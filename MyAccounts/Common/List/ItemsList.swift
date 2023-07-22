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

struct ItemsList<T: ListItem>: View {
    @EnvironmentObject var viewModel: ListViewModel<T>

    var createLabel: String
    var destination: (Binding<T>) -> AnyView
    var itemView: (Binding<T>) -> AnyView
    var createItem: () -> AnyView
    var editItem: (Binding<T>) -> AnyView

    init(
        createLabel: String,
        @ViewBuilder destination: @escaping (Binding<T>) -> AnyView,
        @ViewBuilder itemView: @escaping (Binding<T>) -> AnyView,
        @ViewBuilder createItem: @escaping () -> AnyView,
        @ViewBuilder editItem: @escaping (Binding<T>) -> AnyView
    ) {
        self.createLabel = createLabel
        self.destination = destination
        self.itemView = itemView
        self.createItem = createItem
        self.editItem = editItem
    }

    var body: some View {
        List {
            ForEach($viewModel.items, id: \.itemName) { $item in
                NavigationLink(
                    destination: { destination($item) },
                    label: { itemView($item) }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: { viewModel.showCreateItem = true },
                    label: { Image(systemName: "plus") }
                )
                .accessibilityLabel(createLabel)
            }
        }
        .overlay {
            if viewModel.items.isEmpty {
                Text("NoItems".l)
                    .font(.system(size: 24))
            }
        }
        .sheet(isPresented: $viewModel.showCreateItem) {
            NavigationStack { createItem() }
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showEditItem) {
            NavigationStack {
                if viewModel.itemToEdit != nil {
                    editItem(viewModel.itemToEdit!)
                }
            }
            .presentationDragIndicator(.visible)
        }
        .confirmationDialog(
            Text(viewModel.deleteMessage),
            isPresented: $viewModel.showDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Delete".l, role: .destructive) {
                withAnimation {
                    viewModel.deleteItem()
                }
            }
        }
        .alert(
            Text(viewModel.errorTitle),
            isPresented: $viewModel.showErrorAlert,
            actions: {},
            message: { Text(viewModel.errorMessage) }
        )
    }
}
