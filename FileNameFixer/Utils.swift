//  Utils.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 19.06.25.

import Foundation

func formatBytes(_ bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.countStyle = .file
    return formatter.string(fromByteCount: bytes)
}
