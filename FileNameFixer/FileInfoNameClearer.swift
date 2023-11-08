//  FileInfoNameClearer.swift
//  FileInfoNameClearer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI
import SwiftData

public class FileInfoNameClearer {
    
    private var unwantedWords : [UnwantedWord]
    private var setting:Settings
    
    var fileInfoList : [FileInfo]
    
    init (fileInfoList : [FileInfo])
    {
        self.fileInfoList = fileInfoList
        self.unwantedWords = [UnwantedWord]()
        self.setting = Settings()
    }
    
    func clear(unwantedWords : [UnwantedWord], setting : Settings)
    {
        self.unwantedWords = unwantedWords
        self.setting = setting
        
        if setting.doCleanup {
            doCleanup()
        }
               

    }
    
    private func doCleanup() {
        
        for fileInfo in fileInfoList {
            if setting.replaceDate {
                replaceDate(fileInfo: fileInfo)
            }
            
            if setting.replaceDots {
                replaceDots(fileInfo: fileInfo)
            }
            
            if setting.capitalizeWords {
                capitalizeWords(fileInfo: fileInfo)
            }
            
            if self.unwantedWords.count > 0 {
                removeUnwantedWords(fileInfo: fileInfo)
            }
        }
    }
    
    private func doPrefixes() {
        
    }
        
    private func doSuffixes() {
        
    }
    
    
    /// Remove unwanted Words from Destination Filename
    /// - Parameter fileInfo: FileInfo
    private func removeUnwantedWords(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        for unwantedWord in self.unwantedWords {
            textContent = textContent.replacingOccurrences(of: unwantedWord.word, with: "")
            textContent = textContent.trim()
        }
        
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
    
    /// Replace dots and double dots from destination filename with spaces
    /// - Parameter fileInfo: FileInfo
    private func replaceDots(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        textContent = textContent.replacingOccurrences(of: "..", with: ".")
        textContent = textContent.removeSuffix(".")
        textContent = textContent.replacingOccurrences(of: ".", with: " ")
        textContent = textContent.trim()
        
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
    
    private func capitalizeWords(fileInfo : FileInfo) {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        textContent = textContent.capitalizeWords()
        textContent = textContent.trim()
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
    
    ///  If a date is found in the filename it will be removed and added
    ///  to the front of the filename in a new format
    /// - Parameter fileInfo: FileInfo
    private func replaceDate(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        let matched = matches(for: "[0-9]{2}.[0-9]{2}.[0-9]{2}", in: textContent)
        for match in matched {
            let parts = match.components(separatedBy: ".")
            if parts.count == 3 {
                let newDate =  "20\(parts[0])-\(parts[1])-\(parts[2]) "
                textContent = textContent.replacingOccurrences(of: match, with: "")
                textContent = newDate + textContent
            }
        }
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
    
    private func changeDestinationFileName(fileInfo : FileInfo, newFileName : String)
    {
        var url = URL(fileURLWithPath: fileInfo.destinationFilePathOnly)
        url = url.appendingPathComponent(newFileName + "." + fileInfo.destinationFileExtensionOnly)
        fileInfo.destinationFileNameWithPathExtension = url.path
    }
    
    /// Helper Function for RegEx
    /// - Parameters:
    ///   - regex: Regex to match for
    ///   - text: The string to search in
    /// - Returns: A String array of all matches
    private func matches(for regex: String, in text: String) -> [String]
    {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
