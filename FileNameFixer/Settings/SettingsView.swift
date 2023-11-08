//  SettingsView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 05.09.23.

import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        VStack {
            CleanupPanelView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
