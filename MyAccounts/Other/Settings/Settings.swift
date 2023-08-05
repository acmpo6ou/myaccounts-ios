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

struct Settings: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    var body: some View {
        Form {
            VStack {
                HStack {
                    Image(systemName: "lock.fill")
                    Toggle("LockApp".l, isOn: $viewModel.lockApp)
                        .onChange(of: viewModel.lockApp) { _ in
                            viewModel.save()
                        }
                }
                Text("LockAppTip".l)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            viewModel.initialize()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(SettingsViewModel())
    }
}
