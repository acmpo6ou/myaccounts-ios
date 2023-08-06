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
    @StateObject var lockViewModel = LockViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()

    @Environment(\.scenePhase) var scenePhase
    @State var preparedData = false
    @State var showSettings = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DatabasesList()
                    .toolbar {
                        ToolbarItem(placement: .secondaryAction) {
                            Button("Settings".l) {
                                showSettings = true
                            }
                        }
                    }
                    .onAppear {
                        viewModel.fixSrcFolder()
                        viewModel.loadDatabases()
                        prepareTestData()
                    }
            }
            .environmentObject(viewModel)
            .environmentObject(viewModel as ListViewModel<Database>)
            .sheet(isPresented: $showSettings) {
                Settings()
                    .environmentObject(settingsViewModel)
            }
            .fullScreenCover(isPresented: $lockViewModel.isLocked) {
                LockView()
                    .environmentObject(lockViewModel)
                    .interactiveDismissDisabled()
            }
            .onChange(of: scenePhase) { value in
                let anyDbOpen = viewModel.items.map { $0.isOpen }.contains(true)
                if value != .active
                    && settingsViewModel.lockApp
                    && anyDbOpen {
                    lockViewModel.isLocked = true
                }
            }
        }
    }

    func setupSrcDir() throws {
        let filemgr = FileManager.default
        try? filemgr.removeItem(atPath: Database.srcDir)
        try filemgr.createDirectory(atPath: Database.srcDir, withIntermediateDirectories: false)

        let file1Path = Database.srcDir.replacingOccurrences(of: "src/", with: "file1")
        try? filemgr.removeItem(atPath: file1Path)
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
            try copyDatabase(as: "no_attached")
            try copyDatabase(as: "test")
            try copyDatabase(as: "unsaved")
            viewModel.loadDatabases()

            try viewModel.items[1].open(with: "123")
            try viewModel.items[2].open(with: "123")
            try viewModel.items[3].open(with: "123")
            viewModel.items[3].accounts["gmail"] = nil
            viewModel.items[3].accounts["mega"]?.attachedFiles = [:]
            viewModel.items[1].accounts["gmail"]?.attachedFiles["file2"] = "corrupted content"
        } catch {
            error.log(category: "myaccounts_app")
        }
    }
}
