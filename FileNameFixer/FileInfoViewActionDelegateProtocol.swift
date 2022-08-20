//
//  FileInfoViewActionDelegateProtocol.swift
//  FileNameFixer
//
//  Created by Holger Hinzberg on 20.08.22.
//

import Foundation

protocol FileInfoViewActionDelegateProtocol {
    func remove(fileInfo : FileInfo)
    func edit(fileInfo : FileInfo)
}
