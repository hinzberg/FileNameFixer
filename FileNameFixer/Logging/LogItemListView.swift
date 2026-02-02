//  LogItemListView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 02.02.26.

import SwiftUI

struct LogItemListView: View
{
    @ObservedObject var logsRepo = LogItemRepository.shared
    @State private var messageFilterText = ""
    @State private var selectedPriorityFilter: PriorityFilterOption = .all
    
    private var filteredItems: [LogItem] {
        let messageFilter = messageFilterText.trimmingCharacters(in: .whitespacesAndNewlines)
        return logsRepo.filteredItems(
            messageFilter: messageFilter.isEmpty ? nil : messageFilter,
            priorityFilter: selectedPriorityFilter.asLogItemPriority
        )
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                TextField("Write here to filter", text: $messageFilterText)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2)
                Picker("Priority", selection: $selectedPriorityFilter) {
                    ForEach(PriorityFilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .font(.title2)
                            .tag(option)
                    }
                }
                .pickerStyle(.menu)
                .frame(minWidth: 120)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            List {
                ForEach(filteredItems, id: \.id) { item in
                    LogItemCell(logItem: item)
                        .listRowSeparator(.hidden)
                }
            }
            Spacer()
        }
        .navigationTitle(getWindowTitleWithVersion())
        .toolbar (id: "logs") {
            ToolbarItem(id: "logActions", placement: .destructiveAction) {
                Button {
                    logsRepo.clearAllItems()
                } label: {
                    Label("Clear Logs", systemImage: "trash")
                }
            }
        }
    }
    
    func getWindowTitleWithVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "File Name Fixer - Version \(appVersion!)"
    }
}

struct LogItemListView_Previews: PreviewProvider {
    static var previews: some View {
        LogItemListView()
    }
}
