//
//  CalendarViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import Foundation
import RxSwift
import RxRelay

enum CalendarViewModelEvent {
    
    case reloadData
    case showRecordView(repository: TodoRepository<TodoEntity>, targetDate: Date)
    case showDetailView(repository: TodoRepository<TodoEntity>, entity: TodoEntity)
    
}

final class CalendarViewModel {
    
    enum Section {
        case content([Item])
        
        var items: [Item] {
            switch self {
            case .content(let items):       return items
            }
        }
    }
    
    enum Item {
        case content(CalendarListTableViewCellModel)
    }
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
        self.refresh()
    }
    
    var viewModelEvent: Observable<CalendarViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        self.sections.count
    }
    
    func refresh() {
        if let date = currentDate {
            self.fetchTodoList(date: date)
        } else {
            let date = Date()
            self.currentDate = date
            self.fetchTodoList(date: date)
        }
        
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    func createButtonDidTap() {
        guard let date = self.currentDate else { return }
        self.viewModelEventRelay.accept(.showRecordView(repository: self.todoRepository, targetDate: date))
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        self.sections[safe: section]?.items.count ?? 0
    }
    
    func cellItem(at indexPath: IndexPath) -> Item? {
        return self.sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section], let item = section.items[safe: indexPath.row] else { return }
        switch item {
        case .content(let model):
            let predicate = NSPredicate(format: "targetDate == %@", model.targetDate as NSDate)
            guard let entity = self.todoRepository.getAll(where: predicate).first else { return }
            self.viewModelEventRelay.accept(.showDetailView(repository: self.todoRepository, entity: entity))
        }
    }
    
    func didSelectDate(date: Date) {
        self.currentDate = date
        self.fetchTodoList(date: date)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func fetchTodoList(date: Date) {
//        let formatter = DateFormatter().then {
//            $0.dateFormat = "yyyy년 MM월 dd일"
//            $0.locale = Locale(identifier: "ko_kr")
//        }
        let targetDate = calculator.date(
            year: calculator.year(from: date),
            month: calculator.month(from: date),
            day: calculator.day(from: date)
        )
        let nextDate = calculator.date(byAddingDayValue: 1, to: targetDate!)
        let predicate = NSPredicate(format: "targetDate >= %@ AND targetDate < %@", targetDate! as NSDate, nextDate! as NSDate)
        let items = self.todoRepository.getAll(where: predicate)
            .map { CalendarListTableViewCellModel(text: $0.todo, targetDate: $0.targetDate) }
            .map { Item.content($0) }
        self.sections = [.content(items)]
    }
    
    private var currentDate: Date?
    
    private var sections: [Section] = []
    private let todoRepository: TodoRepository<TodoEntity>
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<CalendarViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
