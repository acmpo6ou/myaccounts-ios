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
    @State var preparedData = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DatabasesList()
                    .onAppear {
                        viewModel.fixSrcFolder()
                        viewModel.loadDatabases()
                        prepareTestData()
                    }
            }
            .environmentObject(viewModel)
            .environmentObject(viewModel as ListViewModel<Database>)
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

    func prepareTestData() {
        let testMode = ProcessInfo
            .processInfo.arguments.contains("testMode")
        if !testMode { return }
        if preparedData { return }
        preparedData = true
        print("PREPARING TEST DATA")

        // speed up animations
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?.layer.speed = 100

        viewModel.items = []
        do {
            try setupSrcDir()
            try copyDatabase()
            try copyDatabase(as: "test")
            try copyDatabase(as: "unsaved")
            viewModel.loadDatabases()
            try viewModel.items[1].open(with: "123")
            try viewModel.items[2].open(with: "123")
            viewModel.items[2].accounts["gmail"] = nil
        } catch {
            error.log(category: "myaccounts_app")
        }
    }
}
