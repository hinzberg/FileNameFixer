//
//  SettingsBackup.swift
//  FileNameFixer
//
//  Created by Cursor on 19.03.26.
//

import Foundation
import SwiftData

/// Codable representation of `SwiftData/Settings.swift` (view + cleanup + prefix/suffix flags).
struct SettingsBackup: Codable {
    var showOnlyFilesToRename: Bool

    // Cleanup
    var doCleanup: Bool
    var replaceDate: Bool
    var replaceDots: Bool
    var replaceUnderscores: Bool
    var capitalizeWords: Bool

    // Prefixes
    var addPrefixes: Bool
    var randomlyChoosePrefix: Bool
    var insertSpaceBetweenPrefixesAndFilenames: Bool

    // Suffixes
    var addSuffixes: Bool
    var randomlyChooseSuffix: Bool
    var insertSpaceBetweenSuffixesAndFilenames: Bool

    enum CodingKeys: String, CodingKey {
        case showOnlyFilesToRename
        case doCleanup
        case replaceDate
        case replaceDots
        case replaceUnderscores
        case capitalizeWords
        case addPrefixes
        case randomlyChoosePrefix
        case insertSpaceBetweenPrefixesAndFilenames
        case addSuffixes
        case randomlyChooseSuffix
        case insertSpaceBetweenSuffixesAndFilenames
    }

    init(
        showOnlyFilesToRename: Bool,
        doCleanup: Bool,
        replaceDate: Bool,
        replaceDots: Bool,
        replaceUnderscores: Bool,
        capitalizeWords: Bool,
        addPrefixes: Bool,
        randomlyChoosePrefix: Bool,
        insertSpaceBetweenPrefixesAndFilenames: Bool,
        addSuffixes: Bool,
        randomlyChooseSuffix: Bool,
        insertSpaceBetweenSuffixesAndFilenames: Bool
    ) {
        self.showOnlyFilesToRename = showOnlyFilesToRename
        self.doCleanup = doCleanup
        self.replaceDate = replaceDate
        self.replaceDots = replaceDots
        self.replaceUnderscores = replaceUnderscores
        self.capitalizeWords = capitalizeWords
        self.addPrefixes = addPrefixes
        self.randomlyChoosePrefix = randomlyChoosePrefix
        self.insertSpaceBetweenPrefixesAndFilenames = insertSpaceBetweenPrefixesAndFilenames
        self.addSuffixes = addSuffixes
        self.randomlyChooseSuffix = randomlyChooseSuffix
        self.insertSpaceBetweenSuffixesAndFilenames = insertSpaceBetweenSuffixesAndFilenames
    }

    init(from settings: Settings) {
        self.showOnlyFilesToRename = settings.showOnlyFilesToRename
        self.doCleanup = settings.doCleanup
        self.replaceDate = settings.replaceDate
        self.replaceDots = settings.replaceDots
        self.replaceUnderscores = settings.replaceUnderscores
        self.capitalizeWords = settings.capitalizeWords
        self.addPrefixes = settings.addPrefixes
        self.randomlyChoosePrefix = settings.randomlyChoosePrefix
        self.insertSpaceBetweenPrefixesAndFilenames = settings.insertSpaceBetweenPrefixesAndFilenames
        self.addSuffixes = settings.addSuffixes
        self.randomlyChooseSuffix = settings.randomlyChooseSuffix
        self.insertSpaceBetweenSuffixesAndFilenames = settings.insertSpaceBetweenSuffixesAndFilenames
    }

    /// Overwrites all mapped `Settings` properties with the values from this backup.
    func apply(to settings: Settings) {
        settings.showOnlyFilesToRename = showOnlyFilesToRename
        settings.doCleanup = doCleanup
        settings.replaceDate = replaceDate
        settings.replaceDots = replaceDots
        settings.replaceUnderscores = replaceUnderscores
        settings.capitalizeWords = capitalizeWords
        settings.addPrefixes = addPrefixes
        settings.randomlyChoosePrefix = randomlyChoosePrefix
        settings.insertSpaceBetweenPrefixesAndFilenames = insertSpaceBetweenPrefixesAndFilenames
        settings.addSuffixes = addSuffixes
        settings.randomlyChooseSuffix = randomlyChooseSuffix
        settings.insertSpaceBetweenSuffixesAndFilenames = insertSpaceBetweenSuffixesAndFilenames
    }
}

