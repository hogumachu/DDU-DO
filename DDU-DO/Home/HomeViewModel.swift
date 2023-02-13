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
    case showRecordView(repository: TodoRepository<TodoEntity>, targetDate: Date)
    case showDetailView(repository: TodoRepository<TodoEntity>, entity: TodoEntity)
    
}

final class HomeViewModel {
    
    enum Section {
        case schedule([Item])
        
        var items: [Item] {
            switch self {
            case .schedule(let items):          return items
            }
        }
    }
    
    enum Item {
        case title(String)
        case schedule(HomeScheduleTableViewCellModel, createdAt: Date)
        case plus(targetDate: Date)
    }
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
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
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .schedule(_, let createdAt):
            let predicate = NSPredicate(format: "createdAt == %@", createdAt as NSDate)
            guard let entity = self.todoRepository.getAll(where: predicate).first else { return }
            self.viewModelEventRelay.accept(.showDetailView(repository: self.todoRepository, entity: entity))
            
        case .plus(let targetDate):
            self.viewModelEventRelay.accept(.showRecordView(repository: self.todoRepository, targetDate: targetDate))
            
        default:
            return
        }
    }
    
    func didSelectComplete(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .schedule(let model, let createdAt):
            let predicate = NSPredicate(format: "createdAt == %@", createdAt as NSDate)
            guard let entity = self.todoRepository.getAll(where: predicate).first else {
                // TODO: - Handle Error
                return
            }
            let newEntity = TodoEntity(todo: entity.todo, isComplete: !model.isComplete, createAt: entity.createAt, targetDate: entity.targetDate)
            do {
                try self.todoRepository.update(item: newEntity)
                self.refresh()
            } catch {
                // TODO: Handle Error
            }
            
        default:
            return
        }
    }
    
    func refresh() {
        self.sections = self.makeSections()
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func makeSections() -> [Section] {
        var sections: [Section] = []
        sections.append(self.makeTodayScheduleSection())
        sections.append(self.makeTomorrowScheduleSection())
        return sections
    }
    
    private func makeTodayScheduleSection() -> Section {
        let today = Date()
        let targetDate = calculator.date(
            year: calculator.year(from: today),
            month: calculator.month(from: today),
            day: calculator.day(from: today)
        )
        let tomorrow = calculator.date(byAddingDayValue: 1, to: targetDate!)
        let predicate = NSPredicate(format: "targetDate >= %@ AND targetDate < %@", targetDate! as NSDate, tomorrow! as NSDate)
        let items = self.todoRepository
            .getAll(where: predicate)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { Item.schedule(.init(text: $0.todo, isComplete: $0.isComplete), createdAt: $0.createAt) }
        return .schedule([.title("오늘 할일")] + items + [.plus(targetDate: targetDate!)])
    }
    
    private func makeTomorrowScheduleSection() -> Section {
        let today = Date()
        let targetDate = calculator.date(
            year: calculator.year(from: today),
            month: calculator.month(from: today),
            day: calculator.day(from: today)
        )
        let tomorrow = calculator.date(byAddingDayValue: 1, to: targetDate!)
        let dayAfterTomorrow = calculator.date(byAddingDayValue: 2, to: targetDate!)
        let predicate = NSPredicate(format: "targetDate >= %@ AND targetDate < %@", tomorrow! as NSDate, dayAfterTomorrow! as NSDate)
        let items = self.todoRepository
            .getAll(where: predicate)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { Item.schedule(.init(text: $0.todo, isComplete: $0.isComplete), createdAt: $0.createAt) }
        return .schedule([.title("내일 할일")] + items + [.plus(targetDate: tomorrow!)])
    }
    
    private func observeTodoRepositoryUpdatedEvent() {
        NotificationCenter.default.addObserver(forName: .todoRepositoryUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.refresh()
        }
    }
    
    private var sections: [Section] = []
    private let todoRepository: TodoRepository<TodoEntity>
    private let calculator = CalendarCalculator()
    private let viewModelEventRelay = PublishRelay<HomeViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
