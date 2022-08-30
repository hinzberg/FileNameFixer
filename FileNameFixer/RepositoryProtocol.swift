//  RepositoryProtocol.swift
//  FileNameFixer
//  Created by Holger Hinzberg on 30.08.22.

import Foundation

protocol RepositoryProtocol {
    associatedtype RepositoryType
    
    func getCount() -> Int
    func add( item:RepositoryType ) -> Void
    func addMany( item:[RepositoryType] ) -> Void
    func remove( item:RepositoryType ) -> Void
    func removeMany( item:[RepositoryType] ) -> Void
    func getAll() -> [RepositoryType]
    func get(id:UUID) ->RepositoryType?
    func clear() -> Void
}
