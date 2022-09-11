//  FileInfoRepository.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation
import Hinzberg_Foundation

public class FileInfoRepository : RepositoryProtocol, ObservableObject
{
    public typealias RepositoryType = FileInfo
    
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
    
    func CleanFileNames() {
        let clearer = FileNameClearer(fileInfoList: self.fileInfoList)
        clearer.clear()
    }
}
