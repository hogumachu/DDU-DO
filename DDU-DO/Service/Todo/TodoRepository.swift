//
//  TodoRepository.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RealmSwift

protocol TodoRepository {
    func getAll(where predicate: NSPredicate?) -> [TodoObject]
    func insert(item: TodoObject) throws
    func update(item: TodoObject) throws
    func delete(item: TodoObject) throws
    func deleteAll() throws
}

final class RealmTodoRepository: TodoRepository {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func getAll(where predicate: NSPredicate?) -> [TodoObject] {
        var objects = realm.objects(TodoObject.self)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        return objects
            .map { $0 }
    }
    
    func insert(item: TodoObject) throws {
        try realm.write {
            realm.add(item)
            self.postTodoRepositoryUpdated()
        }
    }
    
    func update(item: TodoObject) throws {
        try delete(item: item)
        try insert(item: item)
        self.postTodoRepositoryUpdated()
    }
    
    func delete(item: TodoObject) throws {
        try realm.write {
            if let object = realm.objects(TodoObject.self)
                .filter("createdAt == %@", item.createdAt)
                .first {
                realm.delete(object)
                self.postTodoRepositoryUpdated()
            }
        }
    }
    
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
            self.postTodoRepositoryUpdated()
        }
    }
    
    private func postTodoRepositoryUpdated() {
        NotificationCenter.default.post(name: .todoRepositoryUpdated, object: nil)
    }
    
}
