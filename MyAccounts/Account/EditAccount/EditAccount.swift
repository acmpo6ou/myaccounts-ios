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

struct EditAccount: View {
    @StateObject var viewModel = EditAccountViewModel()
    @Binding var database: Database
    @Binding var account: Account
    @Binding var isPresented: Bool

    var body: some View {
        CreateAccount(
            database: $database,
            isPresented: $isPresented,
            applyButtonText: "Save".l
        )
        .environmentObject(viewModel as CreateAccountViewModel)
        .confirmationDialog(
            Text("DetachFileMsg".l),
            isPresented: $viewModel.showDetachConfirm,
            titleVisibility: .visible
        ) {
            Button("Detach".l, role: .destructive) {
                withAnimation {
                    viewModel.detachFile()
                }
            }
        }
        .onAppear {
            viewModel.initialize(
                account: account,
                database: $database
            )
        }
    }
}

struct EditAccount_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}.sheet(isPresented: .constant(true)) {
            NavigationStack {
                ScrollView(.vertical) {
                    EditAccount(
                        database: .constant(Database(name: "main")),
                        account: .constant(testAccount),
                        isPresented: .constant(true)
                    )
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}
