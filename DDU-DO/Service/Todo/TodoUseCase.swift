//
//  TodoUseCase.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation

protocol TodoUseCase: AnyObject {
    func fetch(createdAt: Date) -> [TodoEntity]
    func fetch(start: Date, end: Date) -> [TodoEntity]
    func fetch() -> [TodoEntity]
    func insert(item: TodoEntity) throws
    func update(item: TodoEntity) throws
    func delete(item: TodoEntity) throws
    func deleteAll() throws
}

final class DefaultTodoUseCase: TodoUseCase {
    
    private let repository: TodoRepositoryType
    
    init(repository: TodoRepositoryType) {
        self.repository = repository
    }
    
    func fetch(createdAt: Date) -> [TodoEntity] {
        let predicate = NSPredicate(format: "createdAt == %@", createdAt as NSDate)
        return repository.getAll(where: predicate)
            .map(\.model)
    }
    
    func fetch(start: Date, end: Date) -> [TodoEntity] {
        let predicate = NSPredicate(
            format: "targetDate >= %@ AND targetDate < %@",
            start as NSDate,
            end as NSDate
        )
        return repository.getAll(where: predicate)
            .map(\.model)
    }
    
    func fetch() -> [TodoEntity] {
        return repository.getAll(where: nil)
            .map(\.model)
    }
    
    func insert(item: TodoEntity) throws {
        try repository.insert(item: item.toObject())
    }
    
    func update(item: TodoEntity) throws {
        try repository.update(item: item.toObject())
    }
    
    func delete(item: TodoEntity) throws {
        try repository.delete(item: item.toObject())
    }
    
    func deleteAll() throws {
        try repository.deleteAll()
    }
    
}
