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
    @EnvironmentObject var viewModel: DatabasesListViewModel

    var body: some View {
        List {
            ForEach($viewModel.databases, id: \.name) { $database in
                NavigationLink(
                    destination: {
                        VStack {
                            if database.isOpen {
                                AccountsList(database: $database)
                            } else {
                                OpenDatabase(database: $database)
                            }
                        }
                    },
                    label: { DatabaseItem(database: $database) }
                )
            }
        }
        .navigationTitle("MyAccounts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: { viewModel.showCreateDatabase = true },
                    label: { Image(systemName: "plus") }
                )
                .accessibilityLabel("A11y.CreateDatabase".l)
            }
        }
        .overlay {
            if viewModel.databases.isEmpty {
                Text("NoItems".l)
                    .font(.system(size: 24))
            }
        }
        .sheet(isPresented: $viewModel.showCreateDatabase) {
            CreateDatabase()
        }
        .sheet(isPresented: $viewModel.showEditDatabase) {
            EditDatabase(database: $viewModel.dbToEdit)
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
        .confirmationDialog(
            Text(viewModel.closeMessage),
            isPresented: $viewModel.showCloseAlert,
            titleVisibility: .visible
        ) {
            Button("CloseDBAlert.Save".l) {
                viewModel.saveDatabase()
            }
            Button("CloseDBAlert.Close".l, role: .destructive) {
                viewModel.closeDatabase()
            }
        }
        .alert(
            Text(viewModel.errorTitle),
            isPresented: $viewModel.showErrorAlert,
            actions: {},
            message: { Text(viewModel.errorMessage) }
        )
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
        Group {
            NavigationStack {
                DatabasesList()
                    .previewLayout(.sizeThatFits)
                    .onAppear {
                        viewModel.databases = [Database(name: "main"), Database(name: "test")]
                    }
            }
            NavigationStack {
                DatabasesList()
                    .previewLayout(.sizeThatFits)
                    .onAppear {
                        viewModel.databases = []
                    }
            }
        }
        .environmentObject(viewModel)
    }
}
