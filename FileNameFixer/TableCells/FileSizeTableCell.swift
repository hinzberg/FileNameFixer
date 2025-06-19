//
//  FileSizeTableCell.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 19.06.25.
//

import SwiftUI

struct FileSizeTableCell: View {
    
    let fileInfo : FileInfo
    
    var body: some View {
        
        Text( formatBytes(fileInfo.fileSize ?? 0))
            .font(.title2)
            .foregroundColor(.primary)
    }
}
