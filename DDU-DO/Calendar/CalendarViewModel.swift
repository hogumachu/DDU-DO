//
//  CalendarViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import Foundation
import RxSwift
import RxRelay
import JTAppleCalendar

enum CalendarViewModelEvent {
    
    case reloadData
    case reloadDataWithDate(date: Date)
    case scrollToDate(date: Date, animated: Bool)
    case selectDates(date: Date)
    case showRecordView(useCase: TodoUseCase, targetDate: Date)
    case showDetailView(useCase: TodoUseCase, entity: TodoEntity)
    case updateEmptyView(isHidden: Bool)
    case updateTitle(text: String?)
    case updateDateTitle(text: String?)
    case updateTodayButton(isHidden: Bool)
    
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
        case content(CalendarListTableViewCellModel, createdAt: Date)
    }
    
    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
        self.observeTodoRepositoryUpdatedEvent()
        self.refresh()
    }
    
    var viewModelEvent: Observable<CalendarViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        self.sections.count
    }
    
    func refresh() {
        self.fetchTodoList(date: self.currentDate)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    func createButtonDidTap() {
        self.viewModelEventRelay.accept(.showRecordView(
            useCase: todoUseCase,
            targetDate: self.currentDate
        ))
    }
    
    func todayButtonDidTap() {
        self.currentDate = Date()
        self.viewModelEventRelay.accept(.scrollToDate(date: self.currentDate, animated: true))
        self.viewModelEventRelay.accept(.selectDates(date: self.currentDate))
        self.didSelectDate(date: self.currentDate)
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
        case .content(_, let createdAt):
            guard let entity = todoUseCase.fetch(createdAt: createdAt).first else { return }
            self.viewModelEventRelay.accept(.showDetailView(useCase: todoUseCase, entity: entity))
        }
    }
    
    func didSelectDate(date: Date) {
        self.currentDate = date
        self.fetchTodoList(date: date)
        self.viewModelEventRelay.accept(.updateDateTitle(text: self.dayFormatter.string(from: date)))
        self.viewModelEventRelay.accept(.updateTodayButton(isHidden: date.isDateInToday))
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    func didSelectComplete(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        switch item {
        case .content(let model, let createdAt):
            guard let entity = todoUseCase.fetch(createdAt: createdAt).first else { return }
            let newEntity = TodoEntity(todo: entity.todo, isComplete: !model.isComplete, createAt: entity.createAt, targetDate: entity.targetDate)
            do {
                try todoUseCase.update(item: newEntity)
                self.fetchTodoList(date: entity.targetDate)
            } catch {
                // TODO: Handle Error
            }
        }
        
    }
    
    func willDisplay(date: Date) {
        let title = self.monthFormatter.string(from: date)
        self.viewModelEventRelay.accept(.updateTitle(text: title))
        guard self.isLoading == false else { return }
        if self.calculator.isEqualYearAndMonth(date, self.startDate) {
            self.loadMoreStartDateDataIfEnabled(date: date)
        }
        
        if self.calculator.isEqualYearAndMonth(date, self.endDate) {
           self.loadMoreEndDateDateIfEnabled(date: date)
       }
    }
    
    func calendarItem(state: CellState) -> CalendarDateCellModel {
        let nextDate = self.calculator.date(byAddingDayValue: 1, to: state.date)
        let items = todoUseCase.fetch(start: startDate, end: nextDate!)
        return CalendarDateCellModel(state: state, numberOfItems: items.count)
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
        guard let targetDate, let nextDate else { return }
        let items = todoUseCase.fetch(start: targetDate, end: nextDate)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { Item.content(CalendarListTableViewCellModel(text: $0.todo, isComplete: $0.isComplete), createdAt: $0.createAt) }
        if items.isEmpty {
            self.sections = []
        } else {
            self.sections = [.content(items)]
        }
    }
    
    private func observeTodoRepositoryUpdatedEvent() {
        NotificationCenter.default.addObserver(forName: .todoRepositoryUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.refresh()
        }
    }
    
    private var isLoading = false
    private(set) lazy var startDate = self.calculator.date(byAddingMonthValue: -6, to: Date())!
    private(set) lazy var endDate = self.calculator.date(byAddingMonthValue: 6, to: Date())!
    private var currentDate: Date = Date()
    
    private var sections: [Section] = [] {
        didSet {
            let isHidden = !self.sections.isEmpty
            self.viewModelEventRelay.accept(.updateEmptyView(isHidden: isHidden))
        }
    }
    
    private let monthFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private let dayFormatter = DateFormatter().then {
        $0.dateFormat = "MM.dd"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private let todoUseCase: TodoUseCase
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<CalendarViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
