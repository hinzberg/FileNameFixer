//  FileNameTableCell.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 19.06.25.

import SwiftUI

struct FileNameTableCell: View {
    
    let  fileInfo : FileInfo
    
    var body: some View {
        
        VStack{
            HStack{
                Text(fileInfo.currentFileNameOnly)
                    .font(.title2)
                    .foregroundColor(.primary)
                Spacer()
            }
            HStack{
                Text(fileInfo.destinationFileNameOnly)
                    .font(.title2)
                    .foregroundColor(fileInfo.currentAndDestinationNameAreTheSame ? .green : .red )
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



