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
    
    case updateEditButtonState(isEnabled: Bool)
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
    
    func updateText(text: String) {
        if text.isEmpty {
            self.viewModelEventRelay.accept(.updateEditButtonState(isEnabled: false))
            return
        }
        
        if text == self.todo {
            self.viewModelEventRelay.accept(.updateEditButtonState(isEnabled: false))
            return
        }
        
        self.viewModelEventRelay.accept(.updateEditButtonState(isEnabled: true))
    }
    
    func didTapEdit(text: String?) {
        self.entity = TodoEntity(
            todo: text ?? "",
            isComplete: self.entity.isComplete,
            createAt: self.entity.createAt,
            targetDate: self.entity.targetDate
        )
        do {
            try self.repository.update(item: self.entity)
            self.viewModelEventRelay.accept(.didFinish(message: "수정되었습니다"))
        } catch {
            print("# ERROR: \(error.localizedDescription)")
            self.viewModelEventRelay.accept(.didFail(message: "수정에 실패했습니다"))
        }
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
        let targetDate = self.entity.targetDate
        let newTargetDate = self.calculator.date(byAddingDayValue: 1, to: targetDate)!
        self.entity = TodoEntity(
            todo: self.entity.todo,
            isComplete: self.entity.isComplete,
            createAt: self.entity.createAt,
            targetDate: newTargetDate
        )
        do {
            try self.repository.update(item: self.entity)
            self.viewModelEventRelay.accept(.didFinish(message: "다음 날로 연기되었습니다"))
        } catch {
            print("# ERROR: \(error.localizedDescription)")
            self.viewModelEventRelay.accept(.didFail(message: "변경에 실패했습니다"))
        }
    }
    
    private var entity: TodoEntity
    private let repository: TodoRepository<TodoEntity>
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<TodoDetailViewModelEvent>()
    
}
