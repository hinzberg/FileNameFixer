//  NavigationManagerView.swift
//  PictureDownloader
//  Created by Holger Hinzberg on 16.11.22.

import SwiftUI

struct NavigationManagerView: View {
    
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
            }
        } detail: {
            switch selectedIdentifier {
            case .fileList:
                ContentView()
            case .settings:
                SettingsView()
            }
        }
    }
}

struct NavigationManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
    }
}
