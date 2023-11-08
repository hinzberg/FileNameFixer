//  PrefixesPanelView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 08.11.23.

import SwiftUI
import SwiftData

struct PrefixesPanelView: View {
    
    @State var showingAddSheet = false
    @State private var selected = Set<UUID>()
    // SwiftData
    @Environment(\.modelContext) private var modelContext
    @Query private var prefixes : [Prefix]
    @Query private var settings : [Settings]
        
    var body: some View {
        
        let addPrefixesProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.addPrefixes },
            set: {  self.settings.first!.addPrefixes = $0  }
        )

        var prefixEnabledProxy : Bool {
             get { return self.settings.first!.addPrefixes }
             set {  self.settings.first!.addPrefixes = newValue  }
         }
        
        let randomlyChoosePrefixProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.randomlyChoosePrefix },
            set: {  self.settings.first!.randomlyChoosePrefix = $0  }
        )

        let insertSpaceBetweenPrefixesAndFilenamesProxy : Binding<Bool>  = Binding(
            get: { return self.settings.first!.insertSpaceBetweenPrefixesAndFilenames },
            set: {  self.settings.first!.insertSpaceBetweenPrefixesAndFilenames = $0  }
        )
        
        VStack {
            
            VStack {
                Text("Prefixes")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Toggle("Add Prefixes", isOn:  addPrefixesProxy  )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                Divider()
                
                Toggle("Randomly choose one prefix only", isOn:  randomlyChoosePrefixProxy  )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .disabled(!prefixEnabledProxy)
                
                Toggle("Insert space between prefixes and filename", isOn:  insertSpaceBetweenPrefixesAndFilenamesProxy )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .disabled(!prefixEnabledProxy )
                
                Spacer()
                
            }.frame(maxWidth: .infinity, minHeight: 170 , maxHeight: 170)
            
            HStack{
                Button {
                    showingAddSheet.toggle()
                } label: {
                    Text("Add Prefix")
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    removeSelectedPrefixes()
                } label: {
                    Text("Remove Selected")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            .disabled(!prefixEnabledProxy)
            
            Table(prefixes, selection: $selected ) {
                TableColumn("Prefixess", value: \.word)
                    .width(min: 100, max: 100)
            }
            .tableStyle(.inset)
            .disabled(!prefixEnabledProxy)
            
            Spacer()
        }
        .sheet(isPresented: $showingAddSheet ) {
            showAddPrefixSheet()
        }
    }
    
    func showAddPrefixSheet() -> some View {
        return AddPrefixSheetWindow()
    }
    
    func removeSelectedPrefixes() {
        selected.forEach { id in
            if let item = prefixes.first(where: { $0.id == id }) {
                modelContext.delete(item)
            }
        }
    }
}

#Preview {
    PrefixesPanelView()
}
