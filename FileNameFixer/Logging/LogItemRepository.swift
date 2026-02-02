//  LogItemRepository.swift
//  Created by Holger Hinzberg on 02.02.26.

import Foundation

public class LogItemRepository: ObservableObject {
    
    @Published var logItems = [LogItem]()
    
    // Make this a singleton
    static let shared = LogItemRepository()
    private init() {
        self.addItem(item: LogItem(message: "LogItemRepository Info",  priority: .Information))
        self.addItem(item: LogItem(message: "LogItemRepository Exclamation",  priority: .Exclamation))
        self.addItem(item: LogItem(message: "LogItemRepository Waring",  priority: .Warning))
    }
    
    public func addItem(item : LogItem)
    {
        DispatchQueue.main.async {
            self.logItems.insert(item, at: 0)
        }
    }
    
    /// Removes all log items.
    public func clearAllItems() {
        DispatchQueue.main.async {
            self.logItems.removeAll()
        }
    }
    
    /// Returns log items filtered by optional message substring and/or priority.
    /// - Parameters:
    ///   - messageFilter: If non-nil, only items whose message contains this string (case-insensitive) are included.
    ///   - priorityFilter: If non-nil, only items with this priority are included.
    /// - Returns: Filtered array of log items (original order preserved).
    public func filteredItems(messageFilter: String? = nil, priorityFilter: LogItemPriority? = nil) -> [LogItem] {
        logItems.filter { item in
            let matchesMessage = messageFilter.map { item.message.localizedCaseInsensitiveContains($0) } ?? true
            let matchesPriority = priorityFilter.map { item.priority == $0 } ?? true
            return matchesMessage && matchesPriority
        }
    }
}
