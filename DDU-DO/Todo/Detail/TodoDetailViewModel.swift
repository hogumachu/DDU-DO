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
    
    case didFinish(message: String)
    case didFail(message: String)
    
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
    
    func didTapEdit() {
        
    }
    
    func didTapRemove() {
        do {
            try self.repository.delete(item: self.entity)
            self.viewModelEventRelay.accept(.didFinish(message: "삭제되었습니다"))
        } catch {
            print("# ERROR: \(error.localizedDescription)")
            self.viewModelEventRelay.accept(.didFail(message: "삭제에 실패했습니다"))
        }
    }
    
    func didTapQuickChange() {
        
    }
    
    private var entity: TodoEntity
    private let repository: TodoRepository<TodoEntity>
    private let viewModelEventRelay = PublishRelay<TodoDetailViewModelEvent>()
    
}
