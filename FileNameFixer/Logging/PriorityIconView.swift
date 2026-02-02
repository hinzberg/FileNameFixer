//  PriorityIconView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 02.02.26.

import SwiftUI

struct PriorityIconView: View {
    var priority: LogItemPriority
    
    var body: some View {
        switch priority {
        case .Information:
            Image(systemName: "info.circle")
                .font(.title2)
                .foregroundColor(.green)
        case .Exclamation:
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(.red)
        case .Warning:
            Image(systemName: "questionmark.diamond")
                .font(.title2)
                .foregroundColor(.orange)
        }
    }
}

struct PriorityIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            PriorityIconView(priority: .Information)
            PriorityIconView(priority: .Exclamation)
            PriorityIconView(priority: .Warning)
        }
    }
}
