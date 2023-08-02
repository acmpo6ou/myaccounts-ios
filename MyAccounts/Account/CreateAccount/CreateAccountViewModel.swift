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

class CreateAccountViewModel: CreateViewModel, ErrorModel {
    @Published var username = ""
    @Published var email = ""
    @Published var birthDate = // 01-01-2000
        Date(timeIntervalSince1970: (30 * 365 + 7) * 24 * 60 * 60)
    @Published var notes = ""
    @Published var attachedFiles: [String: URL] = [:]

    @Published var fileToAttach: URL!
    @Published var showAttachFile = false
    @Published var showAttachConfirm = false
    @Published var showGenPass = false

    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    var logCategory = "create_account_model"

    func attachFile(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            let fileName = url.lastPathComponent
            if attachedFiles[fileName] == nil {
                attachedFiles[url.lastPathComponent] = url
            } else {
                fileToAttach = url
                showAttachConfirm = true
            }
        case .failure(let error):
            // TODO: handle
            break
        }
    }

    func replace() {
        attachedFiles[fileToAttach.lastPathComponent] = fileToAttach
    }

    func createAccount() {
    }
}
