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

struct AttachedFiles: View {
    @EnvironmentObject var viewModel: CreateAccountViewModel

    var body: some View {
        List {
            Section {
                ForEach(viewModel.attachedFiles.keys.sorted(), id: \.self) { fileName in
                    Text(fileName).swipeActions {
                        Button {
                            viewModel.willDetachFile(fileName)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .accessibilityLabel("DetachFile".l(fileName))
                        .tint(.red)
                    }
                }
                if viewModel.attachedFiles.keys.sorted().isEmpty {
                    Text("FileListEmpty".l)
                }
            } header: {
                HStack {
                    Text("AttachedFiles".l)
                    Spacer()
                    Button(
                        action: { viewModel.showAttachFile = true },
                        label: { Image(systemName: "plus") }
                    )
                    .accessibilityLabel("AttachFile".l)
                }
            }
        }
    }
}

struct AttachedFiles_Previews: PreviewProvider {
    static func getModel() -> CreateAccountViewModel {
        let viewModel = CreateAccountViewModel()
        viewModel.attachedFiles = [
            "file1": URL(string: "https://")!,
            "file2": URL(string: "https://")!
        ]
        return viewModel
    }

    static var previews: some View {
        AttachedFiles()
            .environmentObject(getModel())
    }
}
