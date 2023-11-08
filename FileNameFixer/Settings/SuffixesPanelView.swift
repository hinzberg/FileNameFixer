//  SuffixesPanelView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 08.11.23.

import SwiftUI
import SwiftData

struct SuffixesPanelView: View {
    
    @State var showingAddSheet = false
    @State private var selected = Set<UUID>()
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var suffixes : [Suffix]
    @Query private var settings : [Settings]
        
    var body: some View {
        
        let addSuffixesProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.addSuffixes },
            set: {  self.settings.first!.addSuffixes = $0  }
        )

        var suffixEnabledProxy : Bool {
             get { return self.settings.first!.addSuffixes }
             set {  self.settings.first!.addSuffixes = newValue  }
         }
        
        let randomlyChoosePrefixProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.randomlyChooseSuffix },
            set: {  self.settings.first!.randomlyChooseSuffix = $0  }
        )

        let insertSpaceBetweenPrefixesAndFilenamesProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.insertSpaceBetweenSuffixesAndFilenames },
            set: {  self.settings.first!.insertSpaceBetweenSuffixesAndFilenames = $0  }
        )
        
        VStack {
            
            VStack {
                Text("Suffixes")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Toggle("Add Suffixes", isOn:  addSuffixesProxy  )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                Divider()
                
                Toggle("Randomly choose one suffix only", isOn:  randomlyChoosePrefixProxy )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .disabled(!suffixEnabledProxy)
                
                Toggle("Insert space between suffix and filename", isOn:  insertSpaceBetweenPrefixesAndFilenamesProxy )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .disabled(!suffixEnabledProxy )
                
                Spacer()
                
            }.frame(maxWidth: .infinity, minHeight: 170 , maxHeight: 170)
            
            HStack{
                Button {
                    showingAddSheet.toggle()
                } label: {
                    Text("Add Suffix")
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    removeSelectedSuffixes()
                } label: {
                    Text("Remove Selected")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            .disabled(!suffixEnabledProxy)
            
            Table(suffixes, selection: $selected ) {
                TableColumn("Suffixes", value: \.word)
                    .width(min: 100, max: 100)
            }
            .tableStyle(.inset)
            .disabled(!suffixEnabledProxy)
            
            Spacer()
        }
        .sheet(isPresented: $showingAddSheet ) {
            showAddSuffixSheet()
        }
    }
    
    func showAddSuffixSheet() -> some View {
        return AddSuffixSheetWindow()
    }
    
    func removeSelectedSuffixes() {
        selected.forEach { id in
            if let item = suffixes.first(where: { $0.id == id }) {
                modelContext.delete(item)
            }
        }
    }
}

#Preview {
    SuffixesPanelView()
}

