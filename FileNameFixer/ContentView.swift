//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI
import SwiftData
import Hinzberg_SwiftUI

struct ContentView: View, FileInfoViewActionDelegateProtocol {
    
    @EnvironmentObject var store: ContentViewStore
    @State var showingRenameSheet = false
    @State var statusText : String = ""
    @State private var selection : FileInfo?
    
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var unwantedWords : [UnwantedWord]
    @Query private var prefixes : [Prefix]
    @Query private var suffixes : [Suffix]
    @Query private var settings : [Settings]
    @Query private var appconfig : [AppConfig]
    
    var body: some View {
        
        var isShowingInspector :Bool {
            get { return self.appconfig.first!.isShowingInspector }
            set {  self.appconfig.first!.isShowingInspector = newValue  }
        }
        
        var isShowingInspectorBinding : Binding<Bool> {
            Binding (
                get: { return isShowingInspector },
                set: {  isShowingInspector = $0  }
            )
        }
        
        VStack {
            
            if store.fileInfoList.count > 0 {
                List (store.fileInfoList, id: \.self, selection: $selection) { fileInfo in
                    FileInfoView(fileInfo: fileInfo, delegate: self)
                        .tag(fileInfo)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                
            } else {
                ContentUnavailableView {
                    Label("No files to rename", systemImage: "questionmark.folder")
                } description: {
                    Text("To get started select the first files")
                } actions: {
                    Button("Select Files") {
                        filePicker()
                        updateStatusText()
                    }.buttonStyle(.link)
                }
            }
            
            StatusView(statusText: $statusText)
                .frame(height: 25)
        }
        .toolbar (id: "main") {
            ToolbarItem(id: "files") {
                Button {
                    filePicker()
                    updateStatusText()
                }  label: {
                    Label("Select Files", systemImage: "folder.badge.plus")
                }
            }
            ToolbarItem(id: "rename") {
                Button(action: rename) {
                    Label("Rename", systemImage: "wand.and.rays")
                }
            }
            ToolbarItem(id: "cleanup") {
                Button(action: clearList) {
                    Label("Clear list", systemImage: "xmark.circle")
                }
            }
            ToolbarItem(id: "inspector") {
                Button(action: {
                    isShowingInspector.toggle()
                } ) {
                    Label("Inspector", systemImage: "sidebar.trailing")
                }
            }
        }
        .sheet(isPresented: $showingRenameSheet ) {
            showTextInputRenameSheet()
        }
        .inspector(isPresented: isShowingInspectorBinding) {
            InspectorView(fileInfo: $selection)
                .inspectorColumnWidth(min: 150, ideal: 150, max: 300)
                .interactiveDismissDisabled()
        }
        .navigationTitle(getWindowTitleWithVersion())
    }
    
    /// Will open a sheet to rename the selected file
    func showTextInputRenameSheet() -> some View {
        return TextInputView(defaultText: store.selectedForRename.fileName) { textContent in
            var url = URL(fileURLWithPath: store.selectedForRename.fileInfo.currentFilePathOnly)
            url = url.appendingPathComponent(textContent + "." + store.selectedForRename.fileInfo.destinationFileExtensionOnly)
            store.selectedForRename.fileInfo.destinationFileNameWithPathExtension = url.path
            updateStatusText()
        }
    }
    
    func getWindowTitleWithVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "File Name Fixer - Version \(appVersion!)"
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
            store.createNewFilenames(unwantedWords: self.unwantedWords, prefixes: self.prefixes, suffixes: self.suffixes, setting: self.settings.first!)
        }
    }
    
    func updateStatusText()
    {
        let totalCount = store.getCount()
        let differentNameCount = store.getFilesPreparedForRenameCount()
        var status = ""
        
        if totalCount == 1 {
            status = "One file selected"
        }
        else if totalCount > 0 {
            status = "\(totalCount) files selected"
        }
        else {
            status = "No file selected"
        }
        
        if differentNameCount == 1 {
            status += " - One file to rename"
        }
        else if differentNameCount > 0 {
            status += " - \(differentNameCount) files to rename"
        }
        
        statusText = status
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
    
    ///  Remove the item from the store. Is called as a delegate from an FileInfoView
    /// - Parameter fileInfo
    func remove(fileInfo: FileInfo) {
        store.remove(item: fileInfo)
        updateStatusText()
    }
    
    ///  Rename the item. Is called as a delegate from an FileInfoView
    /// - Parameter fileInfo
    func edit(fileInfo: FileInfo) {
        store.selectedForRename.fileInfo = fileInfo
        
        // Use the original file name or is there already a new file name set?
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
