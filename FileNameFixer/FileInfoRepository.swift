//  FileInfoRepository.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

public class FileInfoRepository : RepositoryProtocol, ObservableObject
{
    typealias RepositoryType = FileInfo
    
    @Published  var fileInfoList = [FileInfo]()
    
    func getCount() -> Int {
        return fileInfoList.count
    }
    
    func add(item: FileInfo) -> Void {
        fileInfoList.append(item)
    }
    
    func addMany(item: [FileInfo]) -> Void {
    }
    
    func remove(item: FileInfo) -> Void {
        if let i = fileInfoList.firstIndex(of: item) {
            fileInfoList.remove(at: i)
        }
    }
    
    func removeMany(item: [FileInfo]) -> Void {
    }
    
    func getAll() -> [FileInfo] {
        return fileInfoList
    }
    
    func get(id: UUID) -> FileInfo? {
        return nil
    }
    
    func clear() -> Void {
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
