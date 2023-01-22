//
//  HomeViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation

final class HomeViewModel {
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
    }
    
    private let todoRepository: TodoRepository<TodoEntity>
    
}
