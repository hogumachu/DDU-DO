//
//  Repository.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation

protocol Repository {
    
    associatedtype EntityType = Entity
    
    func getAll() -> [EntityType]
    func insert(item: EntityType) throws
    func update(item: EntityType) throws
    func delete(item: EntityType) throws
    
}
