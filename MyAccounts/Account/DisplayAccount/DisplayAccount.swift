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
import AlertToast

struct DisplayAccount: View {
    @StateObject var viewModel = DisplayAccountViewModel()
    var account: Account

    @State var showPassword = false
    @State var showNotes = false

    var body: some View {
        List {
            Section("AccountInfo".l) {
                SpacedText("Username".l, account.username)
                SpacedText("Email".l, account.email)
                DisclosureGroup("Password".l) {
                    Text(account.password)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.disabled)
                        .lineLimit(nil)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                SpacedText("BirthDate".l, account.birthDate)
                DisclosureGroup("Notes".l) {
                    ScrollView {
                        Text(account.notes)
                            .font(.system(.body, design: .monospaced))
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listRowInsets(.init(top: 8, leading: 0, bottom: 0, trailing: 8))
                    .frame(maxHeight: 200)
                }
            }
            let attachedFiles = account.attachedFiles.keys.sorted(by: <)
            if !attachedFiles.isEmpty {
                Section("AttachedFiles".l) {
                    ForEach(attachedFiles, id: \.self) {fileName in
                        Button(fileName) {
                            viewModel.exportFile(fileName)
                        }
                    }
                }
            }
        }
        .navigationTitle(account.accountName)
        .textSelection(.enabled)
        .fileExporter(
            isPresented: $viewModel.showExportFile,
            document: viewModel.document,
            contentType: .data,
            defaultFilename: viewModel.defaultFilename
        ) {
            viewModel.handleExportResult($0)
        }
        .toast(isPresenting: $viewModel.showExportSuccess) {
            AlertToast(
                type: .complete(.green),
                title: "Success".l
            )
        }
        .alert(
            Text(viewModel.errorTitle),
            isPresented: $viewModel.showErrorAlert,
            actions: {},
            message: { Text(viewModel.errorMessage) }
        )
        .onAppear {
            viewModel.account = account
        }
    }
}

struct DisplayAccount_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                DisplayAccount(account: longAccount)
            }
            NavigationStack {
                DisplayAccount(account: accountUnattached)
            }
        }
    }
}
