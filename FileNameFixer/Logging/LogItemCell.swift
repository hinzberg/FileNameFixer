//  LogItemCell.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 02.02.26.

import SwiftUI

struct LogItemCell: View {
    
    var logItem : LogItem
    
    static let timeFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        HStack {
            PriorityIconView(priority: logItem.priority)
            Text( "\(logItem.date, formatter: Self.timeFormat)")
                .font(.title2)
            Text(logItem.message)
                .font(.title2)
            Spacer()
        }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
    }
}

struct LogItemCell_Previews: PreviewProvider {
    
    static var previews: some View {
        LogItemCell(logItem: LogItem(message: "Hello World")  )
    }
}
