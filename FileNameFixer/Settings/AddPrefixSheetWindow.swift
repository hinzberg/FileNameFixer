//  AddPrefixSheetWindow.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 08.11.23.

import SwiftUI
import SwiftData

enum AddPrefixSheetWindowSize {
    static let min = CGSize(width: 450, height: 120)
    static let max = CGSize(width: 450, height: 120)
}

struct AddPrefixSheetWindow: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State var word = "";
    
    var body: some View {
        VStack {
            Text("Add Prefix")
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            TextField("", text: $word)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                    .keyboardShortcut(.cancelAction)
                
                Button("Submit") {
                    self.presentationMode.wrappedValue.dismiss()
                     addPrefix()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }
        .frame(minWidth: AddPrefixSheetWindowSize.min.width, minHeight: AddPrefixSheetWindowSize.min.height)
        .frame(maxWidth: AddPrefixSheetWindowSize.max.width, maxHeight: AddPrefixSheetWindowSize.max.height)
    }
    
    private func addPrefix() {
        let word = Prefix(word: word)
        modelContext.insert(word)
    }
}

#Preview {
    AddPrefixSheetWindow()
}
