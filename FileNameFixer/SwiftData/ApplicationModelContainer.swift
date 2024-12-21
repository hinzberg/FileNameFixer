//  ApplicationModelContainer.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.12.24.

import Foundation
import SwiftData

actor ApplicationModelContainer {
    
    @MainActor
    static func create() -> ModelContainer {
        
        let schema = Schema([
            Settings.self, UnwantedWord.self, Prefix.self, Suffix.self, AppConfig.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            checkForDefaults(container: container)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    @MainActor
    private static func checkForDefaults(container : ModelContainer) {
        
        let settingsCount = (try? container.mainContext.fetchCount(FetchDescriptor<Settings>())) ?? 0
        if  settingsCount == 0 {
            print("No Settings found. Creating default")
            container.mainContext.insert( Settings())
        }
               
        let configCount = (try? container.mainContext.fetchCount(FetchDescriptor<AppConfig>())) ?? 0
        if  configCount == 0 {
            print("No AppConfig found. Creating default")
            container.mainContext.insert( AppConfig())
        }
    }
}
