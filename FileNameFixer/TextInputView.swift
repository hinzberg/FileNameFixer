//  TextInputView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 28.08.22.

import SwiftUI

struct TextInputView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var inputText : String
    @State var description = "Please enter text here";
    private var action :  (String) -> Void
    
    public init (text : String, description : String = "", submitAction: @escaping (String) -> Void) {
        _inputText = State(initialValue: text)
        
        if description != "" {
            _description = State(initialValue: description)
        }
        action = submitAction
    }
    
    var body: some View {
        
        VStack {
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            TextField("", text: $inputText)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            
            HStack {
                Spacer()
                Button("Cancel") { self.presentationMode.wrappedValue.dismiss()}
                    .keyboardShortcut(.cancelAction)
                Button("Submit") {self.presentationMode.wrappedValue.dismiss()
                    action(inputText)
                }.keyboardShortcut(.defaultAction)
            
            }.padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }.frame(width: 400)
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(text: "Hallo Welt") {_ in }
    }
}
