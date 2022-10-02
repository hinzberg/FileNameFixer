//
//  StatusView.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 02.10.22.
//

import SwiftUI

struct StatusView: View {
    
    @Binding var statusText : String
    
    var body: some View {
        VStack{
            Text(statusText)
                        .font(.body)
                        .foregroundColor(.black)
            Spacer()
        }
        

                   
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(statusText: Binding.constant("Hello World"))
    }
}
