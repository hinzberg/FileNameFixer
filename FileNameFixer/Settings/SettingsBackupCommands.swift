//
//  SettingsBackupCommands.swift
//  FileNameFixer
//
//  Created by Cursor on 19.03.26.
//

import SwiftUI
import SwiftData
import AppKit
import UniformTypeIdentifiers

struct SettingsBackupCommands: Commands {
    @Environment(\.modelContext) private var modelContext

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
        let allSettings = (try? modelContext.fetch(FetchDescriptor<Settings>())) ?? []

        // The container already creates a default Settings, but we keep this safe for future changes/migrations.
        let settingsToExport: Settings
        if let existing = allSettings.first {
            settingsToExport = existing
        } else {
            let created = Settings()
            modelContext.insert(created)
            settingsToExport = created
        }

        let backup = SettingsBackup(from: settingsToExport)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        guard let panel = makeSavePanel(defaultFileName: "FileNameFixerSettings.json") else { return }

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try encoder.encode(backup)
                try data.write(to: url, options: [.atomic])
            } catch {
                showErrorAlert(
                    title: "Export Settings Failed",
                    message: error.localizedDescription
                )
            }
        }
    }

    private func importSettingsJSON() {
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
                try modelContext.save()

                showInfoAlert(
                    title: "Import Settings Completed",
                    message: "Imported settings from \"\(url.lastPathComponent)\"."
                )
            } catch {
                showErrorAlert(
                    title: "Import Settings Failed",
                    message: error.localizedDescription
                )
            }
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
}

