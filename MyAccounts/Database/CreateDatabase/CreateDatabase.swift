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

    var applyButtonText = "Create".l

    var body: some View {
        VStack(alignment: .leading) {
            Field(
                label: "DBName".l,
                text: $viewModel.name,
                tip: "DBNameTip".l,
                errorMessage: viewModel.nameError,
                validate: {
                    viewModel.cleanDBName()
                    validate()
                }
            )
            PasswordField(
                label: "Password".l,
                password: $viewModel.password,
                errorMessage: viewModel.passwordError,
                validate: validate
            )
            PasswordField(
                label: "RepeatPassword".l,
                password: $viewModel.repeatPassword,
                validate: validate
            )
            Button("GenPass".l) {
                viewModel.showGenPass = true
            }
            .buttonStyle(.borderedProminent)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.createDatabase()
                } label: {
                    Text(applyButtonText).fontWeight(.semibold)
                        .font(.system(size: 24))
                        .padding()
                }
                .disabled(!viewModel.applyEnabled)
            }
        }
        .modifier(
            GenPass(
                isPresented: $viewModel.showGenPass,
                pass1: $viewModel.password,
                pass2: $viewModel.repeatPassword
            )
        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            viewModel.dbsViewModel = dbsViewModel
        }
    }

    func validate() {
        let takenNames = dbsViewModel.databases.map { $0.name }
        viewModel.applyEnabled(takenNames: takenNames)
    }
}

struct CreateDatabase_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    CreateDatabase()
                        .environmentObject(DatabasesListViewModel())
                }
                .presentationDragIndicator(.visible)
            }
    }
}
