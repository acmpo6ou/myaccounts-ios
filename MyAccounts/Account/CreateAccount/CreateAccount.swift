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

struct CreateAccount: View {
    @EnvironmentObject var viewModel: CreateAccountViewModel
    @Binding var database: Database
    var applyButtonText = "Create".l

    var body: some View {
        VStack(alignment: .leading) {
            Field(
                label: "AccName".l,
                text: $viewModel.name,
                errorMessage: viewModel.nameError,
                validate: {
                    validate()
                }
            )
            Field(
                label: "Username".l,
                text: $viewModel.username,
                validate: {
                    validate()
                }
            )
            Field(
                label: "Email".l,
                text: $viewModel.email,
                validate: {
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
            DatePicker(
                "BirthDate".l,
                selection: $viewModel.birthDate,
                displayedComponents: [.date]
            )
            .font(.system(size: 28))
            Text("Notes".l)
                .font(.system(size: 28))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $viewModel.notes)
                .font(.system(size: 28))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                )
                .frame(minHeight: 200)
            Button("GenPass".l) {
                viewModel.showGenPass = true
            }
            .buttonStyle(.borderedProminent)
            AttachedFiles()
                .frame(width: .infinity, height: 300, alignment: .leading)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.createAccount()
                } label: {
                    Text(applyButtonText).fontWeight(.semibold)
                        .font(.system(size: 24))
                        .padding()
                }
                .disabled(!viewModel.applyEnabled)
            }
        }
        .fileImporter(
            isPresented: $viewModel.showAttachFile,
            allowedContentTypes: [.data]
        ) { result in
            withAnimation {
                viewModel.attachFile(result)
            }
        }
        .confirmationDialog(
            Text("ReplaceAttachMsg".l),
            isPresented: $viewModel.showAttachConfirm,
            titleVisibility: .visible
        ) {
            Button("Replace".l, role: .destructive) {
                withAnimation {
                    viewModel.replace()
                }
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
    }

    func validate() {
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static func getModel() -> CreateAccountViewModel {
        let viewModel = CreateAccountViewModel()
        viewModel.attachedFiles = [
            "file1": "", "file2": "",
            "file3": "", "file9": "",
            "file4": "", "file0": "",
            "file5": "", "file10": "",
            "file6": "", "file11": "",
            "file7": "", "file12": "",
            "file8": "", "file13": ""
        ]
        return viewModel
    }

    static var previews: some View {
        VStack {}.sheet(isPresented: .constant(true)) {
            NavigationStack {
                ScrollView(.vertical) {
                    CreateAccount(database: .constant(Database(name: "main")))
                        .environmentObject(getModel())
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}
