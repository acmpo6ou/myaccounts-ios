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
    @Binding var pass1: String
    @Binding var pass2: String

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            NavigationStack {
                GenPassView(pass1: $pass1, pass2: $pass2)
            }
        }
    }
}

struct GenPassView: View {
    @Binding var pass1: String
    @Binding var pass2: String

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
            Toggle("Lower".l, isOn: $lowerOn)
            Toggle("Upper".l, isOn: $upperOn)
            Toggle("Punct".l, isOn: $punctOn)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    generate()
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

    func generate() {
        var charsToInclude = ""
        if numbersOn { charsToInclude += Chars.numbers }
        if lowerOn { charsToInclude += Chars.lower }
        if upperOn { charsToInclude += Chars.upper }
        if punctOn { charsToInclude += Chars.punct }

        let password = genpass(length: length, chars: charsToInclude)
        pass1 = password
        pass2 = password
    }

    func genpass(length: Int, chars: String) -> String {
        let result = (0..<length).map {_ in chars[Int.random(in: 0...chars.count)]}
        return result.joined()
    }
}

struct GenPass_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}.modifier(
            GenPass(
                isPresented: .constant(true),
                pass1: .constant(""),
                pass2: .constant("")
            )
        )
    }
}

struct Chars {
    static let numbers = "0123456789"
    static let lower = "abcdefghijklmnopqrstuvwxyz"
    static let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let punct = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
}
