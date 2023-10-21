//
//  HomeInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs
import RxSwift

protocol HomeRouting: ViewableRouting {
    func attachSetting()
    func attachRecord(target: Date)
    func attachDetail(entity: TodoEntity)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    func updateSections(_ sections: [HomeSection])
}

protocol HomeListener: AnyObject {}

protocol HomeInteractorDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var calculator: CalendarCalculator { get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
    
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let dependency: HomeInteractorDependency
    
    private var sections: [HomeSection] = []
    
    init(
        presenter: HomePresentable,
        dependency: HomeInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        refresh()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapSetting() {
        router?.attachSetting()
    }
    
    func didSelectAdd(at indexPath: IndexPath) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(_, let targetDate):
            router?.attachRecord(target: targetDate)
            
        default:
            return
        }
    }
    
    func didSelectComplete(at indexPath: IndexPath, tag: Int) {
        guard let section = sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(let model, _):
            guard let todoItem = model.items[safe: tag] else { return }
            guard let entity = dependency.todoUseCase
                .fetch(createdAt: todoItem.createdAt)
                .first else { return }
            let newEntity = TodoEntity(todo: entity.todo, isComplete: !todoItem.isComplete, createAt: entity.createAt, targetDate: entity.targetDate)
            do {
                try dependency.todoUseCase.update(item: newEntity)
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
                .compactMap { dependency.todoUseCase.fetch(createdAt: $0.createdAt).first }
                .map { TodoEntity(todo: $0.todo, isComplete: true, createAt: $0.createAt, targetDate: $0.targetDate) }
            newEntities.forEach {
                do {
                    try dependency.todoUseCase.update(item: $0)
                } catch {
                    // TODO: Handle Error
                }
            }
            self.refresh()
                
            
        default:
            return
        }
    }
    
    func didSelect(at indexPath: IndexPath, tag: Int) {
        guard let section = self.sections[safe: indexPath.section],
              let item = section.items[safe: indexPath.row]
        else {
            return
        }
        
        switch item {
        case .todo(let model, _):
            guard let todoItem = model.items[safe: tag] else { return }
            guard let entity = dependency.todoUseCase.fetch(createdAt: todoItem.createdAt).first else { return }
            router?.attachDetail(entity: entity)
            
        default:
            return
        }
    }
    
    private func refresh() {
        let sections = makeSections()
        self.sections = sections
        presenter.updateSections(sections)
    }
    
    private func makeSections() -> [HomeSection] {
        return [
            makeTodaySection(),
            makeTomorrowTodoSection()
        ]
    }
    
    private func makeTodaySection() -> HomeSection {
        let today = Date()
        let year = dependency.calculator.year(from: today)
        let month = dependency.calculator.month(from: today)
        let day = dependency.calculator.day(from: today)
        guard let targetDate = dependency.calculator.date(year: year, month: month, day: day),
              let tomorrow = dependency.calculator.date(byAddingDayValue: 1, to: targetDate) else {
            return .todo([])
        }
        let items = dependency.todoUseCase
            .fetch(start: targetDate, end: tomorrow)
            .sorted(by: { $0.createAt > $1.createAt })
            .map(HomeTodoItemViewModel.init)
        return .todo([
            .todo(.init(
                title: "오늘 할일",
                subtitle: "\(items.filter { $0.isComplete == false }.count)개 / 총 \(items.count)개",
                items: items,
                type: .today
            ), targetDate: targetDate)]
        )
    }
    
    private func makeTomorrowTodoSection() -> HomeSection {
        let today = Date()
        let year = dependency.calculator.year(from: today)
        let month = dependency.calculator.month(from: today)
        let day = dependency.calculator.day(from: today)
        guard let targetDate = dependency.calculator.date(year: year, month: month, day: day),
              let tomorrow = dependency.calculator.date(byAddingDayValue: 1, to: targetDate),
              let dayAfterTomorrow = dependency.calculator.date(byAddingDayValue: 2, to: targetDate)
        else {
            return .todo([])
        }
        
        let items = dependency.todoUseCase
            .fetch(start: today, end: dayAfterTomorrow)
            .sorted(by: { $0.createAt > $1.createAt })
            .map(HomeTodoItemViewModel.init)
        return .todo([
            .todo(.init(
                title: "내일 할일",
                subtitle: "\(items.count)개",
                items: items,
                type: .etc
            ), targetDate: tomorrow)]
        )
    }
    
}
