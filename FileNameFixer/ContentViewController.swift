//  ContentViewController.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 29.08.22.

import Foundation
import SwiftUI

public class Selected : ObservableObject {
    @Published var fileName = ""
    @Published var fileInfo  = FileInfo()
}

public class ContentViewController :  FileInfoRepository
{
    @Published public var selected = Selected()
}
