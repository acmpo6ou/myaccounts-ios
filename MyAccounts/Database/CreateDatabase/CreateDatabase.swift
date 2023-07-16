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

struct CreateDatabase: View {
    @EnvironmentObject var dbsViewModel: DatabasesListViewModel
    @StateObject var viewModel = CreateDatabaseViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Field(
                label: "DBName".l,
                text: $viewModel.name,
                tip: "DBNameTip".l,
                errorMessage: viewModel.nameError
            )
            PasswordField(
                label: "Password".l,
                password: $viewModel.password,
                errorMessage: viewModel.passwordError
            )
            PasswordField(
                label: "RepeatPassword".l,
                password: $viewModel.repeatPassword,
                tip: "PasswordTip".l
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("CreateDB".l)
    }
}

struct CreateDatabase_Previews: PreviewProvider {
    static var previews: some View {
        CreateDatabase()
            .environmentObject(DatabasesListViewModel())
    }
}
