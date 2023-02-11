//
//  RecordViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/28.
//

import Foundation
import RxSwift
import RxRelay

enum RecordViewModelEvent {
    
    case didFinishRecord(targetDate: Date)
    case didFailRecord(message: String)
    
}

final class RecordViewModel {
    
    init(todoRepository: TodoRepository<TodoEntity>, targetDate: Date) {
        self.todoRepository = todoRepository
        self.targetDate = targetDate
    }
    
    var dateString: String? {
        self.formatter.string(from: self.targetDate)
    }
    
    var weekday: Weekday? {
        self.targetDate.weekday
    }
    
    var viewModelEvent: Observable<RecordViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    func record(_ text: String) {
        guard text.isEmpty == false else {
            self.viewModelEventRelay.accept(.didFailRecord(message: "내용이 없습니다"))
            return
        }
        
        do {
            let entity = TodoEntity(todo: text, isComplete: false, createAt: Date(), targetDate: self.targetDate)
            try self.todoRepository.insert(item: entity)
            self.viewModelEventRelay.accept(.didFinishRecord(targetDate: self.targetDate))
        } catch {
            self.viewModelEventRelay.accept(.didFailRecord(message: "저장에 실패했습니다"))
        }
    }
    
    private let targetDate: Date
    private let todoRepository: TodoRepository<TodoEntity>
    private let formatter = DateFormatter().then {
        $0.dateFormat = "MM월 dd일"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private let viewModelEventRelay = PublishRelay<RecordViewModelEvent>()
    
}
