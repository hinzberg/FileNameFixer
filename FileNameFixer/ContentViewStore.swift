//  ContentViewStore.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 29.08.22.

import Foundation
import SwiftUI
import Hinzberg_Foundation
import Observation

@Observable
public class SelectedInfo {
    var fileName = ""
    var fileInfo  = FileInfo()
}

@Observable
public class ContentViewStore :  RepositoryProtocol, ObservableObject
{
    public typealias RepositoryType = FileInfo
    
    public var selectedForRename = SelectedInfo()
    var fileInfoList = [FileInfo]()
    
    public func getCount() -> Int {
        return fileInfoList.count
    }
    
    public func getFilesPreparedForRenameCount() -> Int
    {
        return fileInfoList.filter{ $0.currentAndDestinationNameAreTheSame == false }.count
    }
          
    public func add(item: FileInfo) -> Void {
        fileInfoList.append(item)
    }
    
    public func addMany(items item: [FileInfo]) -> Void {
    }
    
    public func remove(item: FileInfo) -> Void {
        if let i = fileInfoList.firstIndex(of: item) {
            fileInfoList.remove(at: i)
        }
    }
    
    public func removeMany(items item: [FileInfo]) -> Void {
    }
    
    public func getAll() -> [FileInfo] {
        return fileInfoList
    }
    
    public func get(id: UUID) -> FileInfo? {
        return fileInfoList.first{ $0.id == id}
    }
    
    public func clear() -> Void {
        fileInfoList.removeAll()
    }
   
    func removeAll() -> Void  {
        fileInfoList.removeAll()
    }
    
    func createNewFilenames(unwantedWords : [UnwantedWord], prefixes : [Prefix], suffixes : [Suffix],  setting : Settings)
    {
        let clearer = FileInfoNameClearer(fileInfoList: self.fileInfoList)
        clearer.createNewFilenames(unwantedWords: unwantedWords, prefixes: prefixes, suffixes: suffixes, setting: setting)
    }
}
