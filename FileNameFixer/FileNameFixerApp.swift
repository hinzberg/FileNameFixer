//  FileNameFixerApp.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

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
