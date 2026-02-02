//  LogItemRepository.swift
//  Created by Holger Hinzberg on 02.02.26.

import Foundation

public class LogItemRepository: ObservableObject {
    
    @Published var logItems = [LogItem]()
    
    // Make this a singleton
    static let shared = LogItemRepository()
    private init() {}
    
    public func addItem(item : LogItem)
    {
        DispatchQueue.main.async {
            self.logItems.insert(item, at: 0)
        }
    }
}
