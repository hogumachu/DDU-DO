//
//  TodoDetailViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/30.
//

import Foundation
import RxSwift
import RxRelay
import Then

enum TodoDetailViewModelEvent {
    
}

final class TodoDetailViewModel {
    
    init(repository: TodoRepository<TodoEntity>, entity: TodoEntity) {
        self.repository = repository
        self.entity = entity
    }
    
    var viewModelEvent: Observable<TodoDetailViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var todo: String {
        self.entity.todo
    }
    
    private var entity: TodoEntity
    private let repository: TodoRepository<TodoEntity>
    private let viewModelEventRelay = PublishRelay<TodoDetailViewModelEvent>()
    
}
