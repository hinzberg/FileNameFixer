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

    // Word lists (backup/restore)
    var unwantedWords: [String] = []
    var prefixes: [String] = []
    var suffixes: [String] = []

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
        case unwantedWords
        case prefixes
        case suffixes
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
        insertSpaceBetweenSuffixesAndFilenames: Bool,
        unwantedWords: [String] = [],
        prefixes: [String] = [],
        suffixes: [String] = []
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
        self.unwantedWords = unwantedWords
        self.prefixes = prefixes
        self.suffixes = suffixes
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

    init(
        from settings: Settings,
        unwantedWords: [UnwantedWord],
        prefixes: [Prefix],
        suffixes: [Suffix]
    ) {
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

        // Preserve list contents; SwiftData ids are regenerated on import.
        self.unwantedWords = unwantedWords.map { $0.word }
        self.prefixes = prefixes.map { $0.word }
        self.suffixes = suffixes.map { $0.word }
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

    // Decode compat: earlier versions exported only the `Settings` booleans.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        showOnlyFilesToRename = try container.decode(Bool.self, forKey: .showOnlyFilesToRename)
        doCleanup = try container.decode(Bool.self, forKey: .doCleanup)
        replaceDate = try container.decode(Bool.self, forKey: .replaceDate)
        replaceDots = try container.decode(Bool.self, forKey: .replaceDots)
        replaceUnderscores = try container.decode(Bool.self, forKey: .replaceUnderscores)
        capitalizeWords = try container.decode(Bool.self, forKey: .capitalizeWords)

        addPrefixes = try container.decode(Bool.self, forKey: .addPrefixes)
        randomlyChoosePrefix = try container.decode(Bool.self, forKey: .randomlyChoosePrefix)
        insertSpaceBetweenPrefixesAndFilenames = try container.decode(
            Bool.self,
            forKey: .insertSpaceBetweenPrefixesAndFilenames
        )

        addSuffixes = try container.decode(Bool.self, forKey: .addSuffixes)
        randomlyChooseSuffix = try container.decode(Bool.self, forKey: .randomlyChooseSuffix)
        insertSpaceBetweenSuffixesAndFilenames = try container.decode(
            Bool.self,
            forKey: .insertSpaceBetweenSuffixesAndFilenames
        )

        unwantedWords = try container.decodeIfPresent([String].self, forKey: .unwantedWords) ?? []
        prefixes = try container.decodeIfPresent([String].self, forKey: .prefixes) ?? []
        suffixes = try container.decodeIfPresent([String].self, forKey: .suffixes) ?? []
    }
}

