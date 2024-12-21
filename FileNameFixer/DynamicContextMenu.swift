//  DynamicContextMenu.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 20.12.24.

import SwiftUI

struct DynamicMenuItem {
    var title : String = ""
    var image : String = ""
    var action : () -> Void
    
    init(title : String,  image : String,  action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
}

struct DynamicContextMenuModifier: ViewModifier {
    
    let menuItems : [DynamicMenuItem]
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                ForEach(menuItems, id: \.title) { menuItem in
                    Button(action: menuItem.action) {
                        HStack {
                            Image(systemName: menuItem.image)
                            Text(menuItem.title)
                        }
                    }
                }
            }
    }
}

extension View {
    func dynamicContextMenu(menuItems: [DynamicMenuItem]) -> some View {
        self.modifier(DynamicContextMenuModifier(menuItems: menuItems))
    }
}
