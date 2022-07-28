//
//  FileInfoView.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 17.07.22.
//

import SwiftUI

struct FileInfoView: View {
    var fileInfo : FileInfo
        
    var body: some View {
        VStack{
            HStack {
                Text(fileInfo.currentFileName)
                    .font(.title2)
                Spacer()
            }
            HStack {
                Text(fileInfo.fixedFileName)
                    .font(.title2)
                Spacer()
            }
        }
    }
}

struct FileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FileInfoView(fileInfo: FileInfo(url: URL(fileURLWithPath: "")))
    }
}
