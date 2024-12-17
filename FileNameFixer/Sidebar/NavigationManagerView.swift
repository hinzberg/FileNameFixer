//  NavigationManagerView.swift
//  Created by Holger Hinzberg on 16.11.22.

import SwiftUI
import SwiftData

struct NavigationManagerView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var settings : [Settings]
    @Query private var config : [AppConfig]
    
    var sideBarItems : [NavigationSideBarItem]
    init()
    {
        sideBarItems =  [
            NavigationSideBarItem(displayText: "File List", imageName: "list.dash", identifier: .fileList)
            ,NavigationSideBarItem(displayText: "Settings", imageName: "gear", identifier: .settings)
        ]
    }
    
    @State var sideBarVisibility : NavigationSplitViewVisibility = .doubleColumn
    @State var selectedIdentifier : NavigationSideBarItemIdentifier = .fileList
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(sideBarItems, selection: $selectedIdentifier) { item in
                NavigationLink (value:  item.identifier) {
                    Label("\(item.displayText)", systemImage: item.imageName)
                }
            }.listStyle(.sidebar)
        } detail: {
            switch selectedIdentifier {
            case .fileList:
                ContentView()
            case .settings:
                SettingsView()
                    .background(VisualEffectView())
            }
        }
    }
}

struct NavigationManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
    }
}
