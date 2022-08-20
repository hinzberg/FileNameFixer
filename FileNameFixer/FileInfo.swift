//  FileInfo.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

public class FileInfo : Equatable, Identifiable, ObservableObject
{
    public var id = UUID()
    
    @Published public var fixedFileNameExtension : String
    @Published public var fixedFileNameWithoutExtension : String
    
    // Use this as source to rename file
    public var currentFileNameWithPath : String {
        return self.currentFileUrl.path }
    
    // Use this as destination to rename file
    public var fixedFileNameWithPath : String {
        return self.currentUrlWithOutFilename.appendingPathComponent(fixedFileName).path }
    
    public var currentFileName : String
    
    public var fixedFileName : String {
        return fixedFileNameWithoutExtension + "." + fixedFileNameExtension }
        
    private var currentFileUrl : URL
    private var currentUrlWithOutFilename : URL
    
    convenience init() {
        self.init(url: URL(string: ".")!)
    }
    
    init (url : URL)
    {
        self.currentFileUrl = url
        self.currentUrlWithOutFilename = url.deletingLastPathComponent()
        
        self.currentFileName = url.lastPathComponent
        let file: NSString =  NSString(string: currentFileName)
        self.fixedFileNameExtension = file.pathExtension
        self.fixedFileNameWithoutExtension = file.deletingPathExtension
    }
    
    public static func ==(lhs: FileInfo, rhs: FileInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
