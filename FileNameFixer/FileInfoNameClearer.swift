//  FileInfoNameClearer.swift
//  FileInfoNameClearer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

public class FileInfoNameClearer {
    
    var fileInfoList : [FileInfo]
    
    init (fileInfoList : [FileInfo])
    {
        self.fileInfoList = fileInfoList
    }

    func clear()
    {
        for fileInfo in fileInfoList {
            replaceDate(fileInfo: fileInfo)
            removeUnwantedWords(fileInfo: fileInfo)
            removeUnwantedCharacters(fileInfo: fileInfo)
        }
    }
    
    /// Remove unwanted Words from Destination Filename
    /// - Parameter fileInfo: FileInfo
    private func removeUnwantedWords(fileInfo : FileInfo)
    {
        let unwantedWords = [".XXX", ".SD", "MP4-KLEENEX",".2160p","1080p","720p"]
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
               
        for word in unwantedWords {
            textContent = textContent.replacingOccurrences(of: word, with: "")
        }
        
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
        
    /// Remove unwanted characters from destination filename
    /// - Parameter fileInfo: FileInfo
    private func removeUnwantedCharacters(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        textContent = textContent.replacingOccurrences(of: "..", with: ".")
        textContent = textContent.removeSuffix(".")
        textContent = textContent.replacingOccurrences(of: ".", with: " ")
        textContent = textContent.capitalizeWords()
        
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
