//  AppConfig.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.12.24.

import Foundation
import SwiftData

@Model
public class AppConfig {
    
    @Attribute(.unique) public var Id = UUID()
    
    public var isShowingInspector : Bool = false
    
    init() {
    }
}
