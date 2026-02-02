//  LogItem.swift
//  Created by Holger Hinzberg on 02.02.26.

import Foundation

public enum LogItemPriority {
    case Information
    case Exclamation
    case Warning
}

public class LogItem : Identifiable {
    
    public var id = UUID()
    public var message : String = ""
    public var date = Date()
    public var priority = LogItemPriority.Information
    
    init(message : String) {
        self.message = message
    }
    
    init(message : String, priority : LogItemPriority ) {
        self.message = message
        self.priority = priority
    }
}
