//
//  FileInfo.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 17.07.22.
//

import Foundation

public class FileInfo
{
    public var id = UUID()
    
    public var fixedFileNameExtension : String
    public var fixedFileNameWithoutExtension : String
    
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
    
    init (url : URL)
    {
        self.currentFileUrl = url
        self.currentUrlWithOutFilename = url.deletingLastPathComponent()
        
        self.currentFileName = url.lastPathComponent
        let file: NSString =  NSString(string: currentFileName)
        self.fixedFileNameExtension = file.pathExtension
        self.fixedFileNameWithoutExtension = file.deletingPathExtension
    }
}
