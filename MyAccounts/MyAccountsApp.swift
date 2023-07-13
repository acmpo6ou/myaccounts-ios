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
                DatabasesList()
                    .onAppear {
                        viewModel.fixSrcFolder()
                        viewModel.loadDatabases()
                    }
            }
            .environmentObject(viewModel)
        }
    }

    func setupSrcDir() throws {
        let filemgr = FileManager.default
        try? filemgr.removeItem(atPath: Database.srcDir)
        try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: false)
    }

    func copyDatabase(as name: String = "main") throws {
        let bundle = Bundle(for: DatabasesListViewModel.self)
        let path = bundle.path(forResource: "main", ofType: "dba")!
        try FileManager.default.copyItem(atPath: path, toPath: Database.srcDir + "/\(name).dba")
    }

    func prepareTestData() throws {
//        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil { return }
        try setupSrcDir()
        try copyDatabase()
        try copyDatabase(as: "test")
        viewModel.loadDatabases()
        try viewModel.databases[1].open(with: "123")
    }
}
