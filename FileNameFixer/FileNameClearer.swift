//  FileNameClearer.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

public class FileNameClearer {
    
    var fileInfoList : [FileInfo]
    
    init (fileInfoList : [FileInfo])
    {
        self.fileInfoList = fileInfoList
    }

    func clear()
    {
        for fileInfo in fileInfoList {
            replaceDate(fileInfo: fileInfo)
            removeUnwantedWord(fileInfo: fileInfo)
            removeUnwantedCharacters(fileInfo: fileInfo)
        }
    }
    
    private func removeUnwantedWord(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        let words = [".XXX", ".SD", "MP4-KLEENEX",".2160p","1080p","720p"]
        for word in words {
            textContent = textContent.replacingOccurrences(of: word, with: "")
        }
        
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
    }
    
    private func removeUnwantedCharacters(fileInfo : FileInfo)
    {
        var textContent = fileInfo.destinationFileNameOnlyWithOutExtension
        
        textContent = textContent.replacingOccurrences(of: "..", with: ".")
        textContent = textContent.removeSuffix(".")
        textContent = textContent.replacingOccurrences(of: ".", with: " ")
        textContent = textContent.capitalizeWords()
        
        self.changeDestinationFileName(fileInfo: fileInfo, newFileName: textContent)
   }
    
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
