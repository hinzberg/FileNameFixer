//  SettingsBackupCommands.swift
//  FileNameFixer

import SwiftUI
import SwiftData
import AppKit
import UniformTypeIdentifiers

struct SettingsBackupCommands: Commands {

    private let modelContext: ModelContext
    private let logRepository = LogItemRepository.shared

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Export Settings...") {
                exportSettingsJSON()
            }

            Button("Import Settings...") {
                importSettingsJSON()
            }
        }
    }

    private func exportSettingsJSON() {
        logInfo("Starting settings export")

        do {
            try modelContext.save()
        } catch {
            logError("Export failed while saving pending changes: \(error.localizedDescription)")
            showErrorAlert(
                title: "Export Settings Failed",
                message: "Could not save pending changes before export: \(error.localizedDescription)"
            )
            return
        }
        
        let allSettings = (try? modelContext.fetch(FetchDescriptor<Settings>())) ?? []
        let unwantedWords = (try? modelContext.fetch(FetchDescriptor<UnwantedWord>())) ?? []
        let prefixes = (try? modelContext.fetch(FetchDescriptor<Prefix>())) ?? []
        let suffixes = (try? modelContext.fetch(FetchDescriptor<Suffix>())) ?? []

        // The container already creates a default Settings, but we keep this safe for future changes/migrations.
        let settingsToExport: Settings
        if let existing = allSettings.first {
            settingsToExport = existing
        } else {
            let created = Settings()
            modelContext.insert(created)
            settingsToExport = created
        }

        let backup = SettingsBackup(
            from: settingsToExport,
            unwantedWords: unwantedWords,
            prefixes: prefixes,
            suffixes: suffixes
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        guard let panel = makeSavePanel(defaultFileName: "FileNameFixerSettings.json") else {
            logWarning("Export cancelled: save panel could not be created")
            return
        }

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try encoder.encode(backup)
                try data.write(to: url, options: [.atomic])
                logInfo("Settings export completed: \(url.lastPathComponent)")
            } catch {
                logError("Export failed: \(error.localizedDescription)")
                showErrorAlert(
                    title: "Export Settings Failed",
                    message: error.localizedDescription
                )
            }
        } else {
            logWarning("Settings export cancelled by user")
        }
    }

    private func importSettingsJSON() {
        logInfo("Starting settings import")
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.json]
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let backup = try decoder.decode(SettingsBackup.self, from: data)

                var allSettings = (try? modelContext.fetch(FetchDescriptor<Settings>())) ?? []

                // Ensure we have at least one Settings instance.
                if allSettings.isEmpty {
                    let created = Settings()
                    modelContext.insert(created)
                    allSettings = [created]
                }

                // Overwrite semantics: keep the first, delete any duplicates.
                let settingsToOverwrite = allSettings[0]
                if allSettings.count > 1 {
                    for s in allSettings.dropFirst() {
                        modelContext.delete(s)
                    }
                }

                backup.apply(to: settingsToOverwrite)

                // Overwrite semantics for word lists: clear existing items and replace with the imported ones.
                let existingUnwantedWords = (try? modelContext.fetch(FetchDescriptor<UnwantedWord>())) ?? []
                for w in existingUnwantedWords {
                    modelContext.delete(w)
                }
                for word in backup.unwantedWords {
                    modelContext.insert(UnwantedWord(word: word))
                }

                let existingPrefixes = (try? modelContext.fetch(FetchDescriptor<Prefix>())) ?? []
                for p in existingPrefixes {
                    modelContext.delete(p)
                }
                for word in backup.prefixes {
                    modelContext.insert(Prefix(word: word))
                }

                let existingSuffixes = (try? modelContext.fetch(FetchDescriptor<Suffix>())) ?? []
                for s in existingSuffixes {
                    modelContext.delete(s)
                }
                for word in backup.suffixes {
                    modelContext.insert(Suffix(word: word))
                }

                try modelContext.save()
                logInfo("Settings import completed: \(url.lastPathComponent)")

                showInfoAlert(
                    title: "Import Settings Completed",
                    message: "Imported settings from \"\(url.lastPathComponent)\"."
                )
            } catch {
                logError("Import failed: \(error.localizedDescription)")
                showErrorAlert(
                    title: "Import Settings Failed",
                    message: error.localizedDescription
                )
            }
        } else {
            logWarning("Settings import cancelled by user")
        }
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = title
        alert.informativeText = message
        alert.runModal()
    }

    private func showInfoAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = title
        alert.informativeText = message
        alert.runModal()
    }

    private func makeSavePanel(defaultFileName: String) -> NSSavePanel? {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType.json]
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = defaultFileName
        return panel
    }

    private func logInfo(_ message: String) {
        logRepository.addItem(item: LogItem(message: message, priority: .Information))
    }

    private func logWarning(_ message: String) {
        logRepository.addItem(item: LogItem(message: message, priority: .Warning))
    }

    private func logError(_ message: String) {
        logRepository.addItem(item: LogItem(message: message, priority: .Exclamation))
    }
}

