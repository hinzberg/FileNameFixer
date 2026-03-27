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
            logError("Could not create ModelContainer: \(error.localizedDescription)")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    @MainActor
    private static func checkForDefaults(container : ModelContainer) {
        
        let settingsCount = (try? container.mainContext.fetchCount(FetchDescriptor<Settings>())) ?? 0
        if  settingsCount == 0 {
            print("No Settings found. Creating default")
            logWarning("No Settings found. Creating default")
            container.mainContext.insert( Settings())
        } else {
            logInfo("Settings loaded")
        }
               
        let configCount = (try? container.mainContext.fetchCount(FetchDescriptor<AppConfig>())) ?? 0
        if  configCount == 0 {
            logWarning("No AppConfig found. Creating default")
            container.mainContext.insert( AppConfig())
        } else {
            logInfo("AppConfig loaded")
        }
    }

    private static func logInfo(_ message: String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Information))
    }

    private static func logWarning(_ message: String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Warning))
    }

    private static func logError(_ message: String) {
        LogItemRepository.shared.addItem(item: LogItem(message: message, priority: .Exclamation))
    }
}
