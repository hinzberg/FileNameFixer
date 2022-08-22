//  FileInfo.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import Foundation

public class FileInfo : Equatable, Identifiable, ObservableObject
{
    public var id = UUID()
    
    // MARK: Current File
    
    @Published public var currentFileNameWithPathAndExtension : String = ""
    
    public var currentFileNameOnly : String {
        let file: NSString =  NSString(string: currentFileNameWithPathAndExtension)
        return file.lastPathComponent }
        
    public var currentFilePathOnly : String {
        let file: NSString =  NSString(string: currentFileNameWithPathAndExtension)
        return file.deletingLastPathComponent}
    
    public var currentFileExtensionOnly : String {
        let file: NSString =  NSString(string: currentFileNameWithPathAndExtension)
        return file.pathExtension }
    
    public var currentFileNameOnlyWithOutExtension : String {
        var filename: NSString = NSString(string: currentFileNameWithPathAndExtension)
        filename = NSString(string: filename.lastPathComponent)
        return  filename.deletingPathExtension }
        
    // MARK: Destination File
       
    @Published public var destinationFileNameWithPathExtension : String  = ""
   
    public var destinationFileNameOnly : String {
        let filename: NSString = NSString(string: destinationFileNameWithPathExtension)
        return  filename.lastPathComponent }
    
    public var destinationFilePathOnly : String {
        let file: NSString =  NSString(string: destinationFileNameWithPathExtension)
        return file.deletingLastPathComponent}
    
    public var destinationFileExtensionOnly : String {
        let file: NSString =  NSString(string: destinationFileNameWithPathExtension)
        return file.pathExtension }
    
    public var destinationFileNameOnlyWithOutExtension : String {
        var filename: NSString = NSString(string: destinationFileNameWithPathExtension)
        filename = NSString(string: filename.lastPathComponent)
        return  filename.deletingPathExtension }
    
    // MARK: init
        
    init (currentFileNameWithPathAndExtension : String = "", destinationFileNameWithPathAndExtension : String = "")
    {
        if  currentFileNameWithPathAndExtension != "" {
            self.currentFileNameWithPathAndExtension = currentFileNameWithPathAndExtension}
        
        if  destinationFileNameWithPathAndExtension != "" {
            self.destinationFileNameWithPathExtension = destinationFileNameWithPathAndExtension}
    }
    
    public static func ==(lhs: FileInfo, rhs: FileInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
