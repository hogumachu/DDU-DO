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
    case reloadDataWithDate(date: Date)
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
    
    func willDisplay(date: Date) {
        guard self.isLoading == false else { return }
        if self.calculator.isEqualYearAndMonth(date, self.startDate) {
            self.loadMoreStartDateDataIfEnabled(date: date)
        }
        
        if self.calculator.isEqualYearAndMonth(date, self.endDate) {
           self.loadMoreEndDateDateIfEnabled(date: date)
       }
    }
    
    private func loadMoreStartDateDataIfEnabled(date: Date) {
        guard let newStartDate = self.calculator.date(byAddingMonthValue: -6, to: self.startDate) else { return }
        self.isLoading = true
        let previousDate = self.startDate
        self.startDate = newStartDate
        DispatchQueue.main.async {
            self.viewModelEventRelay.accept(.reloadDataWithDate(date: previousDate))
            self.isLoading = false
        }
    }
    
    private func loadMoreEndDateDateIfEnabled(date: Date) {
        guard let newEndDate = self.calculator.date(byAddingMonthValue: 6, to: self.endDate) else { return }
        self.isLoading = true
        let previousEndDate = self.endDate
        self.endDate = newEndDate
        DispatchQueue.main.async {
            self.viewModelEventRelay.accept(.reloadDataWithDate(date: previousEndDate))
            self.isLoading = false
        }
    }
    
    private func fetchTodoList(date: Date) {
        let targetDate = self.calculator.date(
            year: self.calculator.year(from: date),
            month: self.calculator.month(from: date),
            day: self.calculator.day(from: date)
        )
        let nextDate = self.calculator.date(byAddingDayValue: 1, to: targetDate!)
        let predicate = NSPredicate(format: "targetDate >= %@ AND targetDate < %@", targetDate! as NSDate, nextDate! as NSDate)
        let items = self.todoRepository.getAll(where: predicate)
            .map { CalendarListTableViewCellModel(text: $0.todo, targetDate: $0.targetDate) }
            .map { Item.content($0) }
        self.sections = [.content(items)]
    }
    
    private var isLoading = false
    
    private let formatter = DateFormatter().then {
        $0.dateFormat = "yyyy MM dd"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private(set) lazy var startDate = self.calculator.date(byAddingMonthValue: -6, to: Date())!
    private(set) lazy var endDate = self.calculator.date(byAddingMonthValue: 6, to: Date())!
    private var currentDate: Date?
    
    private var sections: [Section] = []
    private let todoRepository: TodoRepository<TodoEntity>
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<CalendarViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
