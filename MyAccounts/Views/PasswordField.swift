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

import Foundation
import SwiftUI

struct PasswordField: View {
    @FocusState var focus1: Bool
    @FocusState var focus2: Bool
    @State var showPassword: Bool = false
    @Binding var password: String

    var body: some View {
        HStack {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("", text: $password)
                        .modifier(LoginModifier())
                        .focused($focus1)
                        .opacity(showPassword ? 1 : 0)
                    SecureField("", text: $password)
                        .modifier(LoginModifier())
                        .focused($focus2)
                        .opacity(showPassword ? 0 : 1)
                }
                Button {
                    showPassword.toggle()
                    if showPassword { focus1 = true } else { focus2 = true }
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .padding()
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1))
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(.constant(""))
    }
}

struct LoginModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .textContentType(.password)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
    }
}
