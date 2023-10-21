//
//  HomeViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import Foundation
import RxSwift
import RxRelay

enum HomeViewModelEvent {
    
    case reloadData
    case showRecordView(useCase: TodoUseCase, targetDate: Date)
    case showDetailView(useCase: TodoUseCase, entity: TodoEntity)
    case showSettingView(useCase: TodoUseCase)
    
}

final class HomeViewModel {
    
    enum Section {
        case todo([Item])
        
        var items: [Item] {
            switch self {
            case .todo(let items):              return items
            }
        }
    }
    
    enum Item {
        case title(String)
        case todo(HomeTodoTableViewCellModel, targetDate: Date)
    }
    
    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
        self.observeTodoRepositoryUpdatedEvent()
        self.refresh()
    }
    
    var viewModelEvent: Observable<HomeViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        self.sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        self.sections[safe: section]?.items.count ?? 0
    }
    
    func cellItem(at indexPath: IndexPath) -> Item? {
        return self.sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }
    
    func didSelectAdd(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(_, let targetDate):
            self.viewModelEventRelay.accept(.showRecordView(
                useCase: todoUseCase,
                targetDate: targetDate
            ))
            
        default:
            return
        }
    }
    
    func didSelectComplete(indexPath: IndexPath, at tag: Int) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(let model, _):
            guard let todoItem = model.items[safe: tag] else { return }
            guard let entity = todoUseCase.fetch(createdAt: todoItem.createdAt).first else { return }
            let newEntity = TodoEntity(todo: entity.todo, isComplete: !todoItem.isComplete, createAt: entity.createAt, targetDate: entity.targetDate)
            do {
                try todoUseCase.update(item: newEntity)
                self.refresh()
            } catch {
                // TODO: Handle Error
            }
            
        default:
            return
        }
    }
    
    func didSelectAllComplete(indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(let model, _):
            let newEntities = model.items
                .compactMap { todoUseCase.fetch(createdAt: $0.createdAt).first }
                .map { TodoEntity(todo: $0.todo, isComplete: true, createAt: $0.createAt, targetDate: $0.targetDate) }
            newEntities.forEach {
                do {
                    try self.todoUseCase.update(item: $0)
                } catch {
                    // TODO: Handle Error
                }
            }
            self.refresh()
                
            
        default:
            return
        }
    }
    
    func didSelectRow(indexPath: IndexPath, at tag: Int) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(let model, _):
            guard let todoItem = model.items[safe: tag] else { return }
            guard let entity = todoUseCase.fetch(createdAt: todoItem.createdAt).first else { return }
            self.viewModelEventRelay.accept(.showDetailView(useCase: todoUseCase, entity: entity))
            
        default:
            return
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        default:
            return
        }
    }
    
    func didTapNavigationRightButton() {
        self.viewModelEventRelay.accept(.showSettingView(useCase: todoUseCase))
    }
    
    func refresh() {
        self.sections = self.makeSections()
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeSections() -> [Section] {
        var sections: [Section] = []
        sections.append(self.makeTodayTodoSection())
        sections.append(self.makeTomorrowTodoSection())
        return sections
    }
    
    private func makeTodayTodoSection() -> Section {
        let today = Date()
        let targetDate = calculator.date(
            year: calculator.year(from: today),
            month: calculator.month(from: today),
            day: calculator.day(from: today)
        )
        let tomorrow = calculator.date(byAddingDayValue: 1, to: targetDate!)
        guard let targetDate, let tomorrow else {
            return .todo([])
        }
        let items = todoUseCase
            .fetch(start: targetDate, end: tomorrow)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { HomeTodoItemViewModel.init(text: $0.todo, isComplete: $0.isComplete, createdAt: $0.createAt) }
        return .todo([
            .todo(.init(
                title: "오늘 할일",
                subtitle: "\(items.filter { $0.isComplete == false }.count)개 / 총 \(items.count)개",
                items: items,
                type: .today
            ), targetDate: targetDate)]
        )
    }
    
    private func makeTomorrowTodoSection() -> Section {
        let today = Date()
        let targetDate = calculator.date(
            year: calculator.year(from: today),
            month: calculator.month(from: today),
            day: calculator.day(from: today)
        )
        let tomorrow = calculator.date(byAddingDayValue: 1, to: targetDate!)
        let dayAfterTomorrow = calculator.date(byAddingDayValue: 2, to: targetDate!)
        guard let tomorrow, let dayAfterTomorrow else {
            return .todo([])
        }
        let items = todoUseCase
            .fetch(start: today, end: dayAfterTomorrow)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { HomeTodoItemViewModel.init(text: $0.todo, isComplete: $0.isComplete, createdAt: $0.createAt) }
        return .todo([
            .todo(.init(
                title: "내일 할일",
                subtitle: "\(items.count)개",
                items: items,
                type: .etc
            ), targetDate: tomorrow)]
        )
    }
    
    private func observeTodoRepositoryUpdatedEvent() {
        NotificationCenter.default.addObserver(forName: .todoRepositoryUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.refresh()
        }
    }
    
    private var sections: [Section] = []
    private let todoUseCase: TodoUseCase
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<HomeViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
