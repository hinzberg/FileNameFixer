//  String + Extension.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 28.07.22.

import Foundation

extension String {
    
    func removePrefix(_ prefix: String) -> String
    {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeSuffix(_ suffix: String) -> String
    {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    func firstCharacterUppercase() -> String
    {
        var isFirst = true
        var newString = ""
        let characters = Array(self)
        
        for char in characters {
            if isFirst {
                newString = char.uppercased()
            } else {
                newString += String(char)
            }
            isFirst = false
        }
        return newString
    }
    
    func capitalizeWords() -> String
    {
        var newString = "";
        let array = self.components(separatedBy: " ")
        for word in array {
            newString += word.firstCharacterUppercase()
            if word != array.last {
                newString += " "
            }
        }
        return newString
    }
}
