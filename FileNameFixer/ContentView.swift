//  ContentView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI
import SwiftData
import Hinzberg_SwiftUI

struct ContentView: View, FileInfoViewActionDelegateProtocol {
    
    @EnvironmentObject var store: ContentViewStore
    @ObservedObject var logsRepo = LogItemRepository.shared
    @State var showingRenameSheet = false
    @State var statusText : String = ""
    @State private var selectedFileInfoID :  FileInfo.ID? = nil
    @State private var selectedFileInfo : FileInfo? = nil
        
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
        
        var itemsToShow : [FileInfo] {
            if self.settings.first!.showOnlyFilesToRename
            {
                return store.fileInfoList.filter { $0.needToBeRenamed == true }
            }
            return store.fileInfoList
        }
        
        VStack {
            
            // MARK: File Info List View
            
            if itemsToShow.count > 0 {
                
                Table(itemsToShow, selection: $selectedFileInfoID)  {
                                        
                    TableColumn("Filename") { info in
                        FileNameTableCell(fileInfo: info)
                            .frame(maxWidth: .infinity, alignment: .leading)
                     }
                    
                    TableColumn("Size") { info in
                        FileSizeTableCell(fileInfo: info)
                    }
                    .width(100)

                    TableColumn("Actions") { info in
                        ButtonsTableCell(fileInfo: info, delegate: self)
                            .tag(info)
                    }
                    .width(100)
                }
                .onChange(of: selectedFileInfoID) { oldValue, newValue in
                    if let currentSelectedId = newValue {
                        selectedFileInfo = store.get(id: currentSelectedId)
                    }
                }
                
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
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
            }
            
            Spacer()
            
            // MARK: Status Bar
            StatusView(statusText: $statusText)
                .frame(height: 25)
                .onAppear(perform: updateStatusText)
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
            
            ToolbarSpacer(.flexible)
            
            ToolbarItem(id: "hide") {
                Button() {
                    self.settings.first!.showOnlyFilesToRename.toggle()
                    updateStatusText()
                }  label: {
                    Label("Hide / Show Files", systemImage: "eye")
                }
            }
            
            ToolbarSpacer(.flexible)
                        
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
                
                InspectorView(fileInfo: $selectedFileInfo)
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
    
    // MARK: File Picker
    
    func filePicker()
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        if panel.runModal() == .OK
        {
            let fileHelper = FileHelper()
            
            for url in panel.urls {
                let fileSize = fileHelper.getFileSize(from: url)
                let file = FileInfo(currentFileNameWithPathAndExtension: url.path, destinationFileNameWithPathAndExtension: url.path, fileSize: fileSize )
                store.add(item: file)
            }
            store.createNewFilenames(unwantedWords: self.unwantedWords, prefixes: self.prefixes, suffixes: self.suffixes, setting: self.settings.first!)
        }
    }
    
    func updateStatusText()
    {
        let totalCount = store.getCount()
        let differentNameCount = store.needToBeRenamedCount
        var status = ""
        
        if totalCount == 0 {
            statusText = "No files found"
            return
        }
        
        if self.settings.first!.showOnlyFilesToRename  {
            status = "[Show only files to rename] "
        } else {
            status = "[Show all files] "
            
            if totalCount == 0 {
                status += "No file found"
            }
            else if totalCount == 1 {
                status += "One file found"
            }
            else if totalCount > 0 {
                status += "\(totalCount) files found"
            }
        }
        
        if differentNameCount == 0 {
            status += " - No file to rename"
        }
        else if differentNameCount == 1 {
            status += " - One file to rename"
        }
        else if differentNameCount > 0 {
            status += " - \(differentNameCount) files to rename"
        }
        
        statusText = status
    }
    
    // MARK: Rename
    
    func rename()
    {
        var renamedCounter = 0
        let fileHelper = FileHelper()
        let filesToRename = store.fileInfoList.filter { $0.needToBeRenamed == true }
        
        for info in  filesToRename
        {
            do {
                let renameSuccessful = try fileHelper.moveItemAtPath(sourcePath: info.currentFileNameWithPathAndExtension, toPath: info.destinationFileNameWithPathExtension)
                let newFilenameFound = fileHelper.checkIfFileDoesExists(file: info.destinationFileNameWithPathExtension)

                if renameSuccessful && newFilenameFound
                {
                    info.Update()
                    renamedCounter = renamedCounter + 1
                    self.logsRepo.addItem(item: LogItem(message: "File renamed from \(info.currentFileNameWithPathAndExtension) to \(info.destinationFileNameWithPathExtension)" , priority: .Information))
                } else {
                    self.logsRepo.addItem(item: LogItem(message: "Rename failed for \(info.currentFileNameWithPathAndExtension)", priority: .Exclamation))
                }
            }
            catch FileHelperError.fileMove(description: let description)
            {
                self.logsRepo.addItem(item: LogItem(message: "\(description)", priority: .Exclamation))
            }
            catch
            {
                self.logsRepo.addItem(item: LogItem(message: "Unkown Error for \(info.currentFileNameWithPathAndExtension): \(error.localizedDescription)", priority: .Exclamation))
            }
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

