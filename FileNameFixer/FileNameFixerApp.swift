//  FileNameFixerApp.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI
import SwiftData

@main
struct FileNameFixerApp: App {
    
    var contentViewStore = ContentViewStore()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Settings.self, UnwantedWord.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
        }
        .modelContainer(sharedModelContainer)
        .environment(contentViewStore)
    }
}
