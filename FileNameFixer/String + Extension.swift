//  String + Extension.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 28.07.22.

import Foundation

extension String {
    
    func removePrefix(_ prefix: String) -> String
    {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeSuffix(_ suffix: String) -> String
    {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
