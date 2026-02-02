//  FileNameFixerApp.swift
//  Created by Holger Hinzberg

import SwiftUI
import SwiftData

@main
struct FileNameFixerApp: App {
    
    var contentViewStore = ContentViewStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationManagerView()
                .background(VisualEffectView())
        }
        .modelContainer(ApplicationModelContainer.create())
        .environment(contentViewStore)
    }
}
