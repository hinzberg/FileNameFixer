//  FileInfoView.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 17.07.22.

import SwiftUI

struct FileInfoView: View {

    @State var fileInfo : FileInfo
    var delegate : FileInfoViewActionDelegateProtocol?
    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    Text(fileInfo.currentFileNameOnly)
                        .font(.title2)
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    Text(fileInfo.destinationFileNameOnly)
                        .font(.title2)
                        .foregroundColor(fileInfo.currentAndDestinationNameAreTheSame ? .green : .red )
                    Spacer()
                }
            }

            Spacer()
            
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
        .padding(3)
	    }
}

struct Previews_FileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct Previews_FileInfoView_Previews_2: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
