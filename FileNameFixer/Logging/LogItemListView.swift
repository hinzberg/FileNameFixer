//  LogItemListView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 02.02.26.

import SwiftUI

struct LogItemListView: View
{
    @ObservedObject var logsRepo = LogItemRepository.shared
    var body: some View {
        VStack {
            List{
                ForEach (self.logsRepo.logItems, id: \.id) { item in
                    LogItemCell(logItem: item)
                }
            }
            Spacer()
        }
    }
}

struct LogItemListView_Previews: PreviewProvider {
    static var previews: some View {
        LogItemListView()
    }
}
