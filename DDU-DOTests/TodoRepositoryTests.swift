//
//  TodoRepositoryTests.swift
//  DDU-DOTests
//
//  Created by 홍성준 on 2023/03/10.
//

import XCTest
import RealmSwift
@testable import DDU_DO

class TodoRepositoryTests: XCTestCase {
    
    var sut: TodoRepository<TodoEntity>!
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "RepositoryTests"
        sut = TodoRepository<TodoEntity>()
        try! sut.deleteAll()
    }
    
    func test_TodoRepository_초기_entitiy의_수는_0이다() {
        // given
        let initialCount = 0
        
        // when
        let entities = sut.getAll(where: nil)
        let result = entities.count == initialCount
        // then
        let expectation = true
        XCTAssertEqual(result, expectation)
    }
    
    func test_TodoRepository_entity가_추가되면_개수가_repository의_entity개수가_1증가한다() {
        // given
        let expecatationCount = sut.getAll(where: nil).count + 1
        let current = Date()
        let todoEntity = TodoEntity(todo: "Test", isComplete: false, createAt: current, targetDate: current)
        
        // when
        try! sut.insert(item: todoEntity)
        let entities = sut.getAll(where: nil)
        let result = entities.count == expecatationCount
        
        // then
        let expectation = true
        XCTAssertEqual(result, expectation)
    }
    
    func test_TodoRepository_기존에_있는_데이터를_조회할_수_있다() {
        // given
        let current = Date()
        let todoEntity = TodoEntity(todo: "", isComplete: false, createAt: current, targetDate: current)
        try! sut.insert(item: todoEntity)
        
        // when
        let predicate = NSPredicate(format: "createdAt == %@", current as NSDate)
        let entity = sut.getAll(where: predicate).first
        
        // then
        XCTAssertNotNil(entity)
    }
    
    func test_TodoRepository_기존에_추가된_entity를_변경할_수_있다() {
        // given
        let current = Date()
        let beforeUpdateEntityTodo = "Before"
        let afterUpdateEntityTodo = "After"
        let todoEntity = TodoEntity(todo: beforeUpdateEntityTodo, isComplete: false, createAt: current, targetDate: current)
        try! sut.insert(item: todoEntity)
        
        // when
        let newEntity = TodoEntity(todo: afterUpdateEntityTodo, isComplete: false, createAt: current, targetDate: current)
        let predicate = NSPredicate(format: "createdAt == %@", current as NSDate)
        try! sut.update(item: newEntity)
        let entities = sut.getAll(where: predicate)
        let entitiyTodo = entities.first?.todo
        
        
        // then
        let expectation = true
        XCTAssertEqual(expectation, entitiyTodo == afterUpdateEntityTodo)
        XCTAssertEqual(expectation, entities.count == 1)
    }
    
    func test_TodoRepository_기존에_있는_데이터를_제거할_수_있다() {
        // given
        let current = Date()
        let todoEntity = TodoEntity(todo: "", isComplete: false, createAt: current, targetDate: current)
        try! sut.insert(item: todoEntity)
        
        // when
        let predicate = NSPredicate(format: "createdAt == %@", current as NSDate)
        let beforeRemoveEntity = sut.getAll(where: predicate).first
        try! sut.delete(item: todoEntity)
        let afterRemoveEntity = sut.getAll(where: predicate).first
        
        // then
        XCTAssertNotNil(beforeRemoveEntity)
        XCTAssertNil(afterRemoveEntity)
    }
    
    
    func test_TodoRespoitory_모든_데이터를_제거할_수_있다() {
        // given
        let expectationCount = 0
        let current = Date()
        let calendar = Calendar(identifier: .gregorian)
        (1...10)
            .compactMap { calendar.date(byAdding: .minute, value: $0, to: current) }
            .map { TodoEntity(todo: "", isComplete: false, createAt: $0, targetDate: $0) }
            .forEach { try! sut.insert(item: $0) }
        
        // when
        try! sut.deleteAll()
        let result = sut.getAll(where: nil).count == expectationCount
        
        // then
        let expectation = true
        XCTAssertEqual(result, expectation)
    }
    
}
