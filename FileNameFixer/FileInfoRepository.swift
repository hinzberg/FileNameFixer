//  FileInfoRepository.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

class FileInfoRepository : ObservableObject
{
    @Published var fileInfoList = [FileInfo]()
    
    func append( fileInfo : FileInfo) {
        self.fileInfoList.append(fileInfo)
    }
    
    func removeAll() {
        fileInfoList.removeAll()
    }
    
    func remove( fileInfo : FileInfo) {
        
        if let i = fileInfoList.firstIndex(of: fileInfo) {
            fileInfoList.remove(at: i)
        }
    }
    
    func CleanFileNames() {
        let clearer = FileNameClearer(fileInfoList: self.fileInfoList)
        clearer.clear()
    }
}
