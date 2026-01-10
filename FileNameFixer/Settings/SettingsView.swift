//  SettingsView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 05.09.23.

import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        
        VStack {
            GeneralSettingsView()
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            HStack {
                CleanupPanelView()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                PrefixesPanelView()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                SuffixesPanelView()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
        .navigationTitle(getWindowTitleWithVersion())
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
