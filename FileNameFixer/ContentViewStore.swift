//  ContentViewStore.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 29.08.22.

import Foundation
import SwiftUI
import Hinzberg_Foundation

public class SelectedInfo : ObservableObject {
    @Published var fileName = ""
    @Published var fileInfo  = FileInfo()
}

public class ContentViewStore :  RepositoryProtocol, ObservableObject, Observable
{
    public typealias RepositoryType = FileInfo
    
    @Published public var selectedForRename = SelectedInfo()
    @Published  var fileInfoList = [FileInfo]()
    
    public func getCount() -> Int {
        return fileInfoList.count
    }
    
    public func add(item: FileInfo) -> Void {
        fileInfoList.append(item)
    }
    
    public func addMany(item: [FileInfo]) -> Void {
    }
    
    public func remove(item: FileInfo) -> Void {
        if let i = fileInfoList.firstIndex(of: item) {
            fileInfoList.remove(at: i)
        }
    }
    
    public func removeMany(item: [FileInfo]) -> Void {
    }
    
    public func getAll() -> [FileInfo] {
        return fileInfoList
    }
    
    public func get(id: UUID) -> FileInfo? {
        return nil
    }
    
    public func clear() -> Void {
        fileInfoList.removeAll()
    }
   
    func removeAll() -> Void  {
        fileInfoList.removeAll()
    }
    
    func CleanFileNames(unwantedWords : [UnwantedWord], prefixes : [Prefix], suffixes : [Suffix],  setting : Settings)
    {
        let clearer = FileInfoNameClearer(fileInfoList: self.fileInfoList)
        clearer.clear(unwantedWords: unwantedWords, prefixes: prefixes, suffixes: suffixes, setting: setting)
    }
}
