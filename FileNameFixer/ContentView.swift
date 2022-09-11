//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.



import SwiftUI
import Hinzberg_SwiftUI

struct ContentView: View, FileInfoViewActionDelegateProtocol {
    
    @ObservedObject var controller = ContentViewController()
    @State var showingRenameSheet = false
        
    var body: some View {
        VStack {
            List {
                ForEach(controller.fileInfoList, id: \.id) { fileInfo in
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
            showTextInputRenameSheet()
        }
        .navigationTitle("File Name Fixer")
        .frame(width: 800, height: 500)
    }
    
    func showTextInputRenameSheet() -> some View {
        return TextInputView(text: controller.selected.fileName) { textContent in
            var url = URL(fileURLWithPath: controller.selected.fileInfo.currentFilePathOnly)
            url = url.appendingPathComponent(textContent + "." + controller.selected.fileInfo.destinationFileExtensionOnly)
            controller.selected.fileInfo.destinationFileNameWithPathExtension = url.path
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
                controller.add(item: file)
            }
            controller.CleanFileNames()
        }
    }
    
    func rename()
    {
        let fileHelper = FileHelper()
        for info in  controller.fileInfoList
        {
            print("From : \(info.currentFileNameWithPathAndExtension)")
            print("To : \(info.destinationFileNameWithPathExtension)")
            _ = fileHelper.moveItemAtPath(sourcePath: info.currentFileNameWithPathAndExtension, toPath: info.destinationFileNameWithPathExtension)
        }
    }
    
    func clearList()
    {
        controller.removeAll()
    }
    
    func remove(fileInfo: FileInfo) {
        controller.remove(item: fileInfo)
    }
    
    func edit(fileInfo: FileInfo) {
        controller.selected.fileInfo = fileInfo
        
        if fileInfo.currentFileNameOnly == fileInfo.destinationFileNameOnlyWithOutExtension {
            controller.selected.fileName = fileInfo.currentFileNameOnly
        } else {
            controller.selected.fileName = fileInfo.destinationFileNameOnlyWithOutExtension
        }
        showingRenameSheet.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
