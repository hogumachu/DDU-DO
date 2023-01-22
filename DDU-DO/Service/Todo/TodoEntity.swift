//
//  TodoEntity.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RealmSwift

final class TodoEntity {
    
    var todo: String
    var isComplete: Bool
    var createAt: Date
    var targetDate: Date
    
    init(todo: String, isComplete: Bool, createAt: Date, targetDate: Date) {
        self.todo = todo
        self.isComplete = isComplete
        self.createAt = createAt
        self.targetDate = targetDate
    }
    
}

extension TodoEntity: Entity {
    
    private var object: TodoObject {
        let todoObject = TodoObject(todo: self.todo, isComplete: self.isComplete, createdAt: self.createAt, targetDate: self.targetDate)
        return todoObject
    }
    
    func toObject() -> TodoObject {
        return self.object
    }
    
}
