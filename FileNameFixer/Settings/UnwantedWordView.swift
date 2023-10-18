//  UnwantedWordView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 18.10.23.
import SwiftUI

enum UnwantedWordViewWindowSize {
    static let min = CGSize(width: 450, height: 120)
    static let max = CGSize(width: 450, height: 120)
}

struct UnwantedWordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State var word = "";
    
    var body: some View {
        VStack {
            Text("Add an unwanted word")
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
                     addWord()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }
        .frame(minWidth: UnwantedWordViewWindowSize.min.width, minHeight: UnwantedWordViewWindowSize.min.height)
        .frame(maxWidth: UnwantedWordViewWindowSize.max.width, maxHeight: UnwantedWordViewWindowSize.max.height)
    }
    
    private func addWord() {
        var word = UnwantedWord(word: word)
        modelContext.insert(word)
    }
}

#Preview {
    UnwantedWordView()
}
