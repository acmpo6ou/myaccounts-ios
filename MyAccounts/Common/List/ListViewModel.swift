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

class ListViewModel<T: ListItem>: ObservableObject, ErrorModel {
    var logCategory = "list_view_model"
    @Published var showErrorAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""

    @Published var showDeleteAlert = false
    @Published var deleteMessage = ""
    var itemToDelete: T?

    @Published var showCreateItem = false
    @Published var showEditItem = false
    @Published var itemToEdit: Binding<T>?

    /// Displays a confirmation dialog to delete selected item.
    func confirmDelete(of item: T) {
        itemToDelete = item
        deleteMessage = "DeleteItemAlert.Message".l(item.itemName)
        showDeleteAlert = true
    }

    func editItem(_ item: Binding<T>) {
        itemToEdit = item
        showEditItem = true
    }
}
