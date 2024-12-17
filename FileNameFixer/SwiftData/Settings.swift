//  Settings.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 18.10.23.

import Foundation
import SwiftData

@Model
public class Settings {
    
    @Attribute(.unique) public var Id = UUID()
    
    // Cleanup
    public var doCleanup = true
    public var replaceDate = true
    public var replaceDots = true
    public var capitalizeWords = true
    // Prefixes
    public var addPrefixes:Bool = false;
    public var randomlyChoosePrefix:Bool = false;
    public var insertSpaceBetweenPrefixesAndFilenames:Bool = false;
    // Suffixes
    public var addSuffixes:Bool = false;
    public var randomlyChooseSuffix:Bool = false;
    public var insertSpaceBetweenSuffixesAndFilenames:Bool = false;
    
    init() {
    }
}

@Model
public class UnwantedWord : Identifiable {
    
    @Attribute(.unique) public var id = UUID()
    public var word = ""
    
    init(word: String = "") {
        self.word = word
    }
}

@Model
public class Prefix : Identifiable {
    
    @Attribute(.unique) public var id = UUID()
    public var word = ""
    
    init(word: String = "") {
        self.word = word
    }
}

@Model
public class Suffix : Identifiable {
    
    @Attribute(.unique) public var id = UUID()
    public var word = ""
    
    init(word: String = "") {
        self.word = word
    }
}
