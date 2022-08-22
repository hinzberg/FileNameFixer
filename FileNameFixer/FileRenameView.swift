//  FileRenameView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 20.08.22.

import SwiftUI

struct FileRenameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var fileInfo : FileInfo;
    @State var textContent = "Hallo Welt";
    
    public init (fileInfo : Binding<FileInfo>) {
        _fileInfo = fileInfo
    }
        
    var body: some View {
        VStack {
            
            TextField("", text: $textContent)
                .padding()
            
            HStack {
                Spacer()
                Button("Set Name") {
                    var url = URL(fileURLWithPath: fileInfo.currentFilePathOnly)
                    url = url.appendingPathComponent(textContent + "." + fileInfo.destinationFileExtensionOnly)
                    fileInfo.destinationFileNameWithPathExtension = url.path
                    self.presentationMode.wrappedValue.dismiss()
                }.keyboardShortcut(.defaultAction)
                
                Button("Cancel") { self.presentationMode.wrappedValue.dismiss()}
                    .keyboardShortcut(.cancelAction)
                
            }.padding()
        }
            .frame(width: 400)
            .onAppear(perform: {
                if fileInfo.currentFileNameOnly == fileInfo.destinationFileNameOnlyWithOutExtension {
                    textContent = fileInfo.currentFileNameOnly
                } else {
                    textContent = fileInfo.destinationFileNameOnlyWithOutExtension
                }
            } )
    }
}

