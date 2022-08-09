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
        let words = [".XXX", ".SD", "MP4-KLEENEX",".2160p","1080p","720p"]
        for word in words {
            fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.replacingOccurrences(of: word, with: "")
        }
    }
    
    private func removeUnwantedCharacters(fileInfo : FileInfo)
    {
        fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.replacingOccurrences(of: "..", with: ".")
        fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.removeSuffix(".")
        fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.replacingOccurrences(of: ".", with: " ")
        fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.capitalizeWords()
    }
    
    private func replaceDate(fileInfo : FileInfo)
    {
        let matched = matches(for: "[0-9]{2}.[0-9]{2}.[0-9]{2}", in: fileInfo.fixedFileName)
        for match in matched {
            let parts = match.components(separatedBy: ".")
            if parts.count == 3 {
                let newDate =  "20\(parts[0])-\(parts[1])-\(parts[2]) "
                fileInfo.fixedFileNameWithoutExtension = fileInfo.fixedFileNameWithoutExtension.replacingOccurrences(of: match, with: "")
                fileInfo.fixedFileNameWithoutExtension = newDate + fileInfo.fixedFileNameWithoutExtension
            }
        }
        // print(matched)
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
