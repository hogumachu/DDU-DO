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
        case schedule(HomeScheduleTableViewCellModel)
    }
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
        self.sections = self.makeSections()
        self.viewModelEventRelay.accept(.reloadData)
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
        // TODO: - Do Something
    }
    
    private func makeSections() -> [Section] {
        var sections: [Section] = []
        sections.append(self.makeScheduleSection())
        return sections
    }
    
    private func makeScheduleSection() -> Section {
        var items: [Item] = []
        items.append(.title("Test Schedule Section"))
        items.append(.schedule(.init()))
        return .schedule(items)
    }
    
    private var sections: [Section] = []
    private let todoRepository: TodoRepository<TodoEntity>
    private let viewModelEventRelay = PublishRelay<HomeViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
