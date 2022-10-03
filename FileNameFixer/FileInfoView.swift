//  FileInfoView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI

struct FileInfoView: View {

    @ObservedObject var fileInfo : FileInfo
    var delegate : FileInfoViewActionDelegateProtocol?
    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    Text(fileInfo.currentFileNameOnly)
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack {
                    Text(fileInfo.destinationFileNameOnly)
                        .font(.title2)
                        .foregroundColor(fileInfo.currentAndDestinationNameAreTheSame ? .green : .red )
                    Spacer()
                }
            }
            .onTapGesture {
                fileInfo.selected.toggle()
            }
            
            Spacer()
            
            HStack {
                Button {
                    delegate?.edit(fileInfo: self.fileInfo)
                } label: {
                    Image(systemName: "text.quote")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.accentColor)
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
        .padding(3)
        .background(fileInfo.selected ? Color.accentColor.opacity(0.1) : Color(NSColor.controlBackgroundColor) )
        .onTapGesture {
            fileInfo.selected.toggle()
        }
    }
}

/*
struct FileInfoView_Previews: PreviewProvider {
    
    @Binding var fileInfo : FileInfo
    
    static var previews: some View {
        FileInfoView(fileInfo: fileInfo ,delegate: nil)
    }
}
*/
