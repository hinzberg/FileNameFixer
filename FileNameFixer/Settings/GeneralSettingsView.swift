//  GeneralSettingsView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 10.01.26.

import SwiftUI
import SwiftData

struct GeneralSettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var settings : [Settings]

    var body: some View {
        
        let showOnlyFilesToRename : Binding<Bool>  = Binding(
            get: { return self.settings.first!.showOnlyFilesToRename },
            set: {  self.settings.first!.showOnlyFilesToRename = $0  }
        )
                
        VStack {
            Text("General Settings")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            Toggle("Show only files that need to be renamed", isOn: showOnlyFilesToRename)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
        }
    }
}

#Preview {
    GeneralSettingsView()
}
