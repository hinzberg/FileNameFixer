//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var fileInfoRepository = FileInfoRepository()
    
    var body: some View {
        VStack {
            List {
                ForEach(fileInfoRepository.fileInfoList, id: \.id) { fileInfo in
                    FileInfoView(fileInfo: fileInfo)
                }
            }
            Spacer()
        }
        .toolbar (id: "main") {
            ToolbarItem(id: "files") {
                Button(action: filePicker) {
                    Label("Pick Files", systemImage: "folder.badge.plus")
                }
            }
            ToolbarItem(id: "rename") {
                Button(action: rename) {
                        Label("Rename", systemImage: "wand.and.stars")
                }
            }
            ToolbarItem(id: "cleanup") {
                Button(action: clearList) {
                        Label("Clear list", systemImage: "xmark.circle")
                }
            }
        }
        .navigationTitle("File Name Fixer")
        .frame(width: 800, height: 500)
    }
    
    func filePicker()
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        if panel.runModal() == .OK
        {
            for url in panel.urls {
                let file = FileInfo( url:  url)
                self.fileInfoRepository.append(fileInfo: file)
            }
            self.fileInfoRepository.CleanFileNames()
        }
    }
    
    func rename()
    {
        let fileHelper = FileHelper()
        for info in  fileInfoRepository.fileInfoList
        {
            print(info.currentFileNameWithPath + "\n" + info.fixedFileNameWithPath )
            _ = fileHelper.moveItemAtPath(sourcePath: info.currentFileNameWithPath, toPath: info.fixedFileNameWithPath)
        }
    }
    
    func clearList()
    {
        self.fileInfoRepository.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
