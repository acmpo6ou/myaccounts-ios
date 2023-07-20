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

struct OpenDatabase: View {
    @EnvironmentObject var dbViewModel: DatabasesListViewModel
    @StateObject var viewModel = OpenDatabaseViewModel()
    @Binding var database: Database

    var body: some View {
        VStack {
            PasswordField(
                label: "Password",
                password: $viewModel.password,
                errorMessage: viewModel.passwordError,
                validate: {
                    withAnimation {
                        viewModel.passwordError = ""
                    }
                }
            )
            Button {
                viewModel.openDatabase($database)
            } label: {
                Text("OpenDBGeneral".l)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .alert(
            Text(viewModel.errorTitle),
            isPresented: $viewModel.showErrorAlert,
            actions: {},
            message: { Text(viewModel.errorMessage) }
        )
        .navigationTitle("OpenDB".l(database.name))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct OpenDatabase_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OpenDatabase(database: .constant(Database(name: "main")))
                .environmentObject(DatabasesListViewModel())
        }
    }
}
