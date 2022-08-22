//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI

struct ContentView: View, FileInfoViewActionDelegateProtocol {
    
    @ObservedObject var fileInfoRepository = FileInfoRepository()
    @State private var showingRenameSheet = false
    @State var selectedFileInfo : FileInfo = FileInfo()
    
    var body: some View {
        VStack {
            List {
                ForEach(fileInfoRepository.fileInfoList, id: \.id) { fileInfo in
                    FileInfoView(fileInfo: fileInfo, delegate: self)
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
        .sheet(isPresented: $showingRenameSheet ) {
            FileRenameView(fileInfo: $selectedFileInfo)
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
                let file = FileInfo(currentFileNameWithPathAndExtension: url.path, destinationFileNameWithPathAndExtension: url.path)
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
            print("From : \(info.currentFileNameWithPathAndExtension)")
            print("To : \(info.destinationFileNameWithPathExtension)")
            _ = fileHelper.moveItemAtPath(sourcePath: info.currentFileNameWithPathAndExtension, toPath: info.destinationFileNameWithPathExtension)
        }
    }
    
    func clearList()
    {
        self.fileInfoRepository.removeAll()
    }
    
    func remove(fileInfo: FileInfo) {
        self.fileInfoRepository.remove(fileInfo: fileInfo)
    }
    
    func edit(fileInfo: FileInfo) {
        selectedFileInfo = fileInfo
        showingRenameSheet.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
