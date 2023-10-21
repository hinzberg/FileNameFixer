//  SettingsView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 05.09.23.

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @State var showingAddSheet = false
    @State private var selected = Set<UUID>()
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var unwantedWords : [UnwantedWord]
    @Query private var settings : [Settings]
    
    var body: some View {
        
        let replaceDateProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.replaceDate },
            set: {  self.settings.first!.replaceDate = $0  }
        )

        let replaceDotsProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.replaceDots },
            set: {  self.settings.first!.replaceDots = $0  }
        )
        
        let capitalizeWordsProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.capitalizeWords },
            set: {  self.settings.first!.capitalizeWords = $0  }
        )
                
        VStack {
            Toggle("Replace Date", isOn:  replaceDateProxy  )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            Toggle("Replace Dots with Spaces", isOn:  replaceDotsProxy  )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            Toggle("Capitalize Words", isOn:  capitalizeWordsProxy  )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            HStack{
                Button("Add Word", action: {  showingAddSheet.toggle()  })
                Button("Remove Selected", action: {  removeSelectedWords()  })
                Spacer()
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            Table(unwantedWords, selection: $selected ) {
                TableColumn("Unwanted Words", value: \.word)
                    .width(min: 150, max: 300)
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            .tableStyle(.inset)
            
            Spacer()
        }
        .navigationTitle(getWindowTitleWithVersion())
        .sheet(isPresented: $showingAddSheet ) {
            showAddWordSheet()
        }
    }
    
    func showAddWordSheet() -> some View {
        return UnwantedWordView()
    }
    
    func removeSelectedWords() {
        selected.forEach { id in
            if let item = unwantedWords.first(where: { $0.id == id }) {
                modelContext.delete(item)
            }
        }
    }
    
    func getWindowTitleWithVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "File Name Fixer - Version \(appVersion!)"
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
