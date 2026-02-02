//  PriorityFilterOption.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 02.02.26.

import SwiftUI

public enum PriorityFilterOption: String, CaseIterable {
    case all = "All"
    case information = "Information"
    case exclamation = "Exclamation"
    case warning = "Warning"
    
    var asLogItemPriority: LogItemPriority? {
        switch self {
        case .all: return nil
        case .information: return .Information
        case .exclamation: return .Exclamation
        case .warning: return .Warning
        }
    }
    
    /// SF Symbol name matching LogItemCell icons.
    var iconSystemName: String {
        switch self {
        case .all: return "line.3.horizontal.decrease.circle"
        case .information: return "info.circle"
        case .exclamation: return "exclamationmark.triangle"
        case .warning: return "questionmark.diamond"
        }
    }
    
    /// Color matching LogItemCell.
    var iconColor: Color {
        switch self {
        case .all: return .primary
        case .information: return .green
        case .exclamation: return .red
        case .warning: return .orange
        }
    }
}
