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

struct DatabasesList: View {
    @ObservedObject var viewModel: DatabasesListViewModel

    var body: some View {
        List {
            ForEach(viewModel.databases, id: \.name) { database in
                DatabaseItem(database: database)
                    .swipeActions {
                        Button(
                            action: { viewModel.confirmDelete(of: database) },
                            label: { Image(systemName: "trash.fill") }
                        )
                        .tint(.red)
                    }
                    .transition(.slide)
            }
        }
        .confirmationDialog(
            Text(viewModel.deleteMessage),
            isPresented: $viewModel.showDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Delete".l, role: .destructive) {
                withAnimation {
                    viewModel.deleteDatabase()
                }
            }
        }
        .refreshable {
            withAnimation {
                viewModel.loadDatabases()
            }
        }
    }
}

struct DatabasesList_Previews: PreviewProvider {
    static let viewModel = DatabasesListViewModel()
    static var previews: some View {
        DatabasesList(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .onAppear {
                viewModel.databases = [Database(name: "main"), Database(name: "test")]
            }
    }
}
