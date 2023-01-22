//
//  TodoObject.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RealmSwift

final class TodoObject: Object {
    
    @Persisted private(set) var todo: String
    @Persisted private(set) var isComplete: Bool
    @Persisted private(set) var createdAt: Date
    @Persisted private(set) var targetDate: Date
    
    convenience init(
        todo: String,
        isComplete: Bool,
        createdAt: Date,
        targetDate: Date
    ) {
        self.init()
        self.todo = todo
        self.isComplete = isComplete
        self.createdAt = createdAt
        self.targetDate = targetDate
    }
    
    var model: TodoEntity {
        get { TodoEntity(todo: self.todo, isComplete: self.isComplete, createAt: self.createdAt, targetDate: self.targetDate) }
    }
    
}
