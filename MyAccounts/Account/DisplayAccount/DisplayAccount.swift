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

struct DisplayAccount: View {
    var account: Account
    @State var showPassword = false
    @State var showNotes = false
    let hiddenText = String(repeating: "●", count: 10)

    var body: some View {
        List {
            Section("AccountInfo".l) {
                SpacedText("Username".l, account.username)
                SpacedText("Email".l, account.email)
                Button {
                    showPassword.toggle()
                } label: {
                    SpacedText(
                        "Pass".l,
                        showPassword ? account.password : hiddenText
                    )
                }
                SpacedText("BirthDate".l, account.birthDate)
                DisclosureGroup("Notes".l) {
                    ScrollView {
                        Text(account.notes)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(maxHeight: 200)
                }
            }
            .navigationTitle(account.accountName)
        }
    }
}

struct DisplayAccount_Previews: PreviewProvider {
    static var previews: some View {
        DisplayAccount(account: longAccount)
    }
}
