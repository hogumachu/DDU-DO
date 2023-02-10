//
//  TodoRepository.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RealmSwift

final class TodoRepository<RepositoryObject>: Repository where RepositoryObject: Entity, RepositoryObject.ObjectType: TodoObject {
    
    typealias ObjectType = RepositoryObject.ObjectType
    
    private let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func getAll(where predicate: NSPredicate?) -> [RepositoryObject] {
        var objects = realm.objects(ObjectType.self)
        
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        
        return objects
            .compactMap { $0 }
            .compactMap { $0.model as? RepositoryObject }
    }
    
    func insert(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toObject())
            self.postTodoRepositoryUpdated()
        }
    }
    
    func update(item: RepositoryObject) throws {
        try delete(item: item)
        try insert(item: item)
        self.postTodoRepositoryUpdated()
    }
    
    func delete(item: RepositoryObject) throws {
        try realm.write {
            if let object = realm.objects(ObjectType.self)
                .filter("createdAt == %@", item.toObject().createdAt)
                .first {
                realm.delete(object)
                self.postTodoRepositoryUpdated()
            }
        }
    }
    
    private func postTodoRepositoryUpdated() {
        NotificationCenter.default.post(name: .todoRepositoryUpdated, object: nil)
    }
    
}
