//
//  InspectorView.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 11.11.23.
//

import SwiftUI

struct InspectorView: View {
    
    @Binding var fileInfo : FileInfo?
    
    var body: some View {
        Text("Hallo \(fileInfo?.destinationFileNameOnlyWithOutExtension ?? "Nothing")")
    }
}

#Preview {
    InspectorView(fileInfo: .constant(FileInfo()))
}
