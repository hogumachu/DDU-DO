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
    
    init() {
        self.sections = self.makeSections()
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    var viewModelEvent: Observable<CalendarViewModelEvent> {
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
    
    func didSelectDate(date: Date) {
        self.fetchTodoList(date: date)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    private func fetchTodoList(date: Date) {
        // TODO: - Repository 에서 Date 를 통해 값 가져오기
        let formatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일"
            $0.locale = Locale(identifier: "ko_kr")
        }
        self.sections = [.content([.content(.init(text: formatter.string(from: date)))])]
    }
    
    private func makeSections() -> [Section] {
        var sections: [Section] = []
        sections.append(self.makeContentSection())
        return sections
    }
    
    private func makeContentSection() -> Section {
        var items: [Item] = []
        items.append(.content(.init(text: "Test Test 1")))
        items.append(.content(.init(text: "Test Test 2")))
        items.append(.content(.init(text: "Test Test 3")))
        return .content(items)
    }
    
    private var sections: [Section] = []
    private let viewModelEventRelay = PublishRelay<CalendarViewModelEvent>()
    private let disposeBag = DisposeBag()
    
}
