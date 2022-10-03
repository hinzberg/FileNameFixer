//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI
import Hinzberg_SwiftUI

struct ContentView: View, FileInfoViewActionDelegateProtocol {
    
    @ObservedObject var store = ContentViewStore()
    @State var showingRenameSheet = false
    @State var statusText : String = ""
        
    var body: some View {
        VStack {
            List {
                ForEach(store.fileInfoList, id: \.id) { fileInfo in
                    FileInfoView(fileInfo: fileInfo, delegate: self)
                }.listRowInsets(EdgeInsets())
            }.listStyle(PlainListStyle())
       
            StatusView(statusText: $statusText)
                .frame(height: 25)
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
                        Label("Clear list", systemImage: "trash.fill")
                }
            }
        }
        .sheet(isPresented: $showingRenameSheet ) {
            showTextInputRenameSheet()
        }
        .navigationTitle("File Name Fixer")
        .frame(width: 800, height: 500)
    }
    
    func showTextInputRenameSheet() -> some View {
        return TextInputView(defaultText: store.selectedForRename.fileName) { textContent in
            var url = URL(fileURLWithPath: store.selectedForRename.fileInfo.currentFilePathOnly)
            url = url.appendingPathComponent(textContent + "." + store.selectedForRename.fileInfo.destinationFileExtensionOnly)
            store.selectedForRename.fileInfo.destinationFileNameWithPathExtension = url.path
        }
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
                store.add(item: file)
            }
            
            store.CleanFileNames()

            if store.getCount() == 1 {
                statusText = "One file selected"
            }
            else if store.getCount() > 0 {
                statusText = "\(store.getCount()) files selected"
            }
            else {
                statusText = "No file selected"
            }
        }
    }
    
    func rename()
    {
        var renamedCounter = 0
        let fileHelper = FileHelper()
        let filesToRename = store.fileInfoList.filter { $0.currentAndDestinationNameAreTheSame == false }
        
        for info in  filesToRename
        {
            print("From : \(info.currentFileNameWithPathAndExtension)")
            print("To : \(info.destinationFileNameWithPathExtension)")
            _ = fileHelper.moveItemAtPath(sourcePath: info.currentFileNameWithPathAndExtension, toPath: info.destinationFileNameWithPathExtension)
            renamedCounter = renamedCounter + 1
        }
        
        if renamedCounter == 1 {
            statusText = "One file renamed"
        }
        else if store.getCount() > 0 {
            statusText = "\(renamedCounter) files renamed"
        }
        else {
            statusText = "No file renamed"
        }
    }
    
    func clearList()
    {
        store.removeAll()
        statusText = ""
    }
    
    func remove(fileInfo: FileInfo) {
        store.remove(item: fileInfo)
    }
    
    func edit(fileInfo: FileInfo) {
        store.selectedForRename.fileInfo = fileInfo
        
        if fileInfo.currentFileNameOnly == fileInfo.destinationFileNameOnlyWithOutExtension {
            store.selectedForRename.fileName = fileInfo.currentFileNameOnly
        } else {
            store.selectedForRename.fileName = fileInfo.destinationFileNameOnlyWithOutExtension
        }
        showingRenameSheet.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
