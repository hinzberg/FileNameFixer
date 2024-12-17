//  HHSFileHelper.swift
//  Created by Holger Hinzberg on 20.06.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.

import Foundation

public class FileHelper
{
    public func getDocumentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0] as String
    }

    public func checkIfFolderDoesExists(folder:String, createIfNotExits:Bool) -> Bool
    {
        let isDir:UnsafeMutablePointer<ObjCBool>? = nil
        let exists = FileManager.default.fileExists(atPath: folder, isDirectory: isDir)
        
        if exists == false && createIfNotExits == true
        {
            var error: NSError?
            do
            {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error1 as NSError
            {
                error = error1
            }
            print(error!.localizedDescription)
        }
        return true
    }
    
    public func checkIfFileDoesExists(file:String) -> Bool
    {
        let exists = FileManager.default.fileExists(atPath: file)
        
        if exists == false {
            return false
        }
        return true
    }
    
    // MARK: Copy file
    public func copyItemAtUrl(sourceURL : URL, toURL destinationURL : URL) -> Bool
    {
        return copyItemAtPath(sourcePath: sourceURL.path, toPath: destinationURL.path)
    }
    
    func copyItemAtPath(sourcePath: String?, toPath destinationPath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = sourcePath, let destinationPath = destinationPath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
             }
            catch let error as NSError
            {
                print("Could not copy \(sourcePath) : \(error.localizedDescription)")
                success = false;
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
            success = false;
        }
        return success
    }
    
    // MARK: Move file, can also do rename
    
    func moveItemAtUrl(sourceUrl : URL, toURL destinationURL: URL) -> Bool
    {
        return moveItemAtPath(sourcePath: sourceUrl.path, toPath: destinationURL.path)
    }
        
    func moveItemAtPath(sourcePath: String?, toPath destinationPath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = sourcePath, let destinationPath = destinationPath
        {
            do  {
                try FileManager.default.moveItem(atPath: sourcePath, toPath: destinationPath)
            }
            catch let error as NSError
            {
                print("Could not move \(sourcePath) : \(error.localizedDescription)")
                success = false;
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
            success = false;
        }
        return success
    }
        
    func copyFiles(sourceUrls:[URL], toUrl destinationUrl: URL) -> Int
    {
        var copyCounter = 0;
        
        for sourceUrl in sourceUrls
        {
            // Get only the Filename
            let originalFilename = sourceUrl.lastPathComponent;
            // Create an destinationpath with the filename
            let destinationFilename = destinationUrl.path + "/" + originalFilename;
            // Copy from source to destination
            let success = self.copyItemAtPath(sourcePath: sourceUrl.path, toPath: destinationFilename)
            if  success == true
            {
                copyCounter += 1
            }
        }        
        return copyCounter;
    }
    
    func deleteItemAtPath(sourcePath: String?) -> Bool
    {
        var success = true
        
        if let sourcePath = sourcePath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.removeItem(atPath: sourcePath)
            }
            catch let error as NSError
            {
                print("Could not delete \(sourcePath) : \(error.localizedDescription)")
                success = false;
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
            success = false;
        }
        return success
    }
}
