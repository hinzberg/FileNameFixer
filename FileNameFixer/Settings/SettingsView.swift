//  SettingsView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 05.09.23.

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @State var showingAddSheet = false
    @State var settings = Settings()
    @State private var selected = Set<UUID>()
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var unwantedWords : [UnwantedWord]
    
    var body: some View {
        
        VStack {
            Toggle("Replace Date", isOn: $settings.replaceDate)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
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
