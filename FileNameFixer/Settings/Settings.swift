//  Settings.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 18.10.23.

import Foundation
import SwiftData

@Model
public class Settings {
    
    @Attribute(.unique) public var Id = UUID()
    public var replaceDate = true
    public var replaceDots = true
    public var capitalizeWords = true
    
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


