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

struct GenPass: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            NavigationStack {
                GenPassView()
            }
        }
    }
}

struct GenPassView: View {
    @State private var length = 16
    @State private var numbersOn = true
    @State private var lowerOn = true
    @State private var upperOn = true
    @State private var punctOn = true

    var body: some View {
        VStack {
            HStack {
                Text("PassLen".l)
                Picker("", selection: $length) {
                    ForEach(8...128, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 100)
            }

            Toggle("Numbers".l, isOn: $numbersOn)
            Toggle("Lower".l, isOn: $numbersOn)
            Toggle("Upper".l, isOn: $numbersOn)
            Toggle("Punct".l, isOn: $numbersOn)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Text("Generate".l).fontWeight(.semibold)
                        .font(.system(size: 24))
                        .padding()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct GenPass_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}.modifier(
            GenPass(isPresented: .constant(true))
        )
    }
}
