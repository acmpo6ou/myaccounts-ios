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

protocol ErrorModel: AnyObject {
    var showErrorAlert: Bool { get set }
    var errorTitle: String { get set }
    var errorMessage: String { get set }
    var logCategory: String { get }
}

extension ErrorModel {
    func showError(_ error: Error, title: String) {
        log(error)
        errorTitle = title
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }

    func log(_ error: Error) {
        error.log(category: logCategory)
    }
}
