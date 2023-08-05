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

    private var destination: (Binding<Database>) -> AnyView = { database in
        AnyView(
            VStack {
                if database.wrappedValue.isOpen {
                    var accsViewModel = AccountsListViewModel(database)
                    AccountsList(database: database)
                        .transition(.opacity.animation(.easeInOut))
                        .environmentObject(accsViewModel)
                        .environmentObject(accsViewModel as ListViewModel<Account>)
                } else {
                    OpenDatabase(database: database)
                }
            }
        )
    }

    var body: some View {
        ItemsList<Database>(
            createLabel: "CreateDB".l,
            destination: destination,
            itemView: { AnyView(DatabaseItem(database: $0)) },
            createItem: { AnyView(CreateDatabase()) },
            editItem: { AnyView(EditDatabase(database: $0)) }
        )
        .navigationTitle("MyAccounts")
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
                    .onAppear {
                        viewModel.items = [Database(name: "main"), Database(name: "test")]
                    }
            }
            NavigationStack {
                DatabasesList()
                    .onAppear {
                        viewModel.items = []
                    }
            }
        }
        .environmentObject(viewModel)
        .previewLayout(.sizeThatFits)
    }
}
