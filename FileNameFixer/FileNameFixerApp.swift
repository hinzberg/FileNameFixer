//  FileNameFixerApp.swift
//  Created by Holger Hinzberg

import SwiftUI
import SwiftData

@main
struct FileNameFixerApp: App {
    
    var contentViewStore = ContentViewStore()
    private let modelContainer = ApplicationModelContainer.create()
    
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
               // .background(VisualEffectView())
        }
        .modelContainer(modelContainer)
        .environment(contentViewStore)
        .commands {
            SettingsBackupCommands(modelContext: modelContainer.mainContext)
        }
    }
}
