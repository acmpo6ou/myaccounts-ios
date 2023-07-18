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

struct Field: View {
    let label: String
    @Binding var text: String
    var tip = ""
    var errorMessage = ""
    let validate: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: 28))
            TextField("", text: $text)
                .onChange(of: text) {_ in validate() }
                .accessibilityLabel(label)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(errorMessage.isEmpty ? .gray : .red, lineWidth: 1)
                )
            Text(errorMessage.isEmpty ? tip : "")
                .foregroundColor(.gray)
            Text(errorMessage)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct Field_Previews: PreviewProvider {
    @State static var password1 = ""
    static var previews: some View {
        VStack {
            Field(
                label: "DBName".l,
                text: $password1,
                tip: "Helpful tip."
            ) {}
            Field(
                label: "DBName".l,
                text: $password1,
                tip: "Helpful tip.",
                errorMessage: "Incorrect name!"
            ) {}
        }
        .padding()
    }
}
