//  InspectorView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 11.11.23.

import SwiftUI
import QuickLook

struct InspectorView: View {
    
    @Binding var fileInfo : FileInfo?
    @State var documentUrl: URL?
    
    var body: some View {
        
        VStack {
            
            if  fileInfo != nil {
                Text(fileInfo!.currentFileNameOnly)
                    .padding(4)
                
                Text(URL(fileURLWithPath: fileInfo!.currentFileNameWithPathAndExtension).fileSizeString )
                    .padding(4)
                
                Button("Show Quicklook", action: {
                    documentUrl = URL(fileURLWithPath: fileInfo!.currentFileNameWithPathAndExtension)
                })
                .padding(4)
                .quickLookPreview($documentUrl)
                
                Spacer()
                
            } else {
                Text("No Selection")
                    .padding(4)
            }
        }
    }
}

#Preview {
    InspectorView(fileInfo: .constant(FileInfo()))
}
