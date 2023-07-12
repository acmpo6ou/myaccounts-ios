//
//  MyAccountsApp.swift
//  MyAccounts
//
//  Created by Catalyst on 28/06/2023.
//

import SwiftUI

@main
struct MyAccountsApp: App {
    let viewModel = DatabasesListViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DatabasesList(viewModel: viewModel)
                    .onAppear {
                        viewModel.fixSrcFolder()
                        viewModel.loadDatabases()
                    }
            }
        }
    }
}
