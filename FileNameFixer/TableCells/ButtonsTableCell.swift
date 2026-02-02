//  ButtonsTableCell.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 19.06.25.

import SwiftUI

struct ButtonsTableCell: View {
    
    let fileInfo : FileInfo
    var delegate : FileInfoViewActionDelegateProtocol?
    
    var body: some View {
        
        HStack {
            Button {
                delegate?.edit(fileInfo: self.fileInfo)
            } label: {
                Image(systemName: "highlighter")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.primary)
            }  .buttonStyle(.borderless)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            
            Button {
                delegate?.remove(fileInfo: self.fileInfo)
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.red)
            }  .buttonStyle(.borderless)
        }
        
    }
}
