//
//  Entity.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RealmSwift

protocol Entity {
    
    associatedtype ObjectType = Object
    func toObject() -> ObjectType
    
}
