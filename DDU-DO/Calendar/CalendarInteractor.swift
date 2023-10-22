//
//  CalendarInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs
import RxSwift
import JTAppleCalendar

protocol CalendarRouting: ViewableRouting {}

protocol CalendarPresentable: Presentable {
    var listener: CalendarPresentableListener? { get set }
    var calendarDataSource: CalendarDataSource? { get set }
    func updateSections(_ sections: [CalendarSection])
    func updateTitle(_ title: String)
    func reloadData(date: Date)
}

protocol CalendarListener: AnyObject {}

protocol CalendarInteractorDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var calculator: CalendarCalculator { get }
}

final class CalendarInteractor: PresentableInteractor<CalendarPresentable>, CalendarInteractable, CalendarPresentableListener, CalendarDataSource {
    
    weak var router: CalendarRouting?
    weak var listener: CalendarListener?
    
    private let dependency: CalendarInteractorDependency
    private var currentDate = Date()
    private(set) lazy var startDate = dependency.calculator.date(byAddingMonthValue: -6, to: Date())!
    private(set) lazy var endDate = dependency.calculator.date(byAddingMonthValue: 6, to: Date())!
    private let monthFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private let dayFormatter = DateFormatter().then {
        $0.dateFormat = "MM.dd"
        $0.locale = Locale(identifier: "ko_kr")
    }
    private var isLoading = false
    
    init(presenter: CalendarPresentable, dependency: CalendarInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.calendarDataSource = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        refresh()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapCreate() {
        
    }
    
    func didTapToday() {
        
    }
    
    func didSelect(at indexPath: IndexPath) {
        
    }
    
    func didSelect(date: Date) {
        currentDate = date
        let sections = makeTodoList(date: date)
        presenter.updateSections(sections)
    }
    
    func didSelectComplete(at indexPath: IndexPath) {
        
    }
    
    func willDisplay(date: Date) {
        let title = self.monthFormatter.string(from: date)
        presenter.updateTitle(title)
        guard !isLoading else { return }
        if dependency.calculator.isEqualYearAndMonth(date, startDate) {
            loadMoreStartDateDataIfEnabled(date: date)
        }
        
        if dependency.calculator.isEqualYearAndMonth(date, endDate) {
            loadMoreEndDateDateIfEnabled(date: date)
        }
    }
    
    func calendarItem(state: CellState) -> CalendarDateCellModel {
        let nextDate = dependency.calculator.date(byAddingDayValue: 1, to: state.date)
        let items = dependency.todoUseCase.fetch(start: startDate, end: nextDate!)
        return CalendarDateCellModel(state: state, numberOfItems: items.count)
    }
    
    private func loadMoreStartDateDataIfEnabled(date: Date) {
        guard let newStartDate = dependency.calculator.date(
            byAddingMonthValue: -6,
            to: startDate
        ) else { return }
        isLoading = true
        let previousDate = startDate
        startDate = newStartDate
        DispatchQueue.main.async {
            self.presenter.reloadData(date: previousDate)
            self.isLoading = false
        }
    }
    
    private func loadMoreEndDateDateIfEnabled(date: Date) {
        guard let newEndDate = dependency.calculator.date(
            byAddingMonthValue: 6,
            to: endDate
        ) else { return }
        isLoading = true
        let previousEndDate = endDate
        endDate = newEndDate
        DispatchQueue.main.async {
            self.presenter.reloadData(date: previousEndDate)
            self.isLoading = false
        }
    }
    
    
    private func refresh() {
        let sections = makeTodoList(date: Date())
        presenter.updateSections(sections)
    }
    
    private func makeTodoList(date: Date) -> [CalendarSection] {
        let targetDate = dependency.calculator.date(
            year: dependency.calculator.year(from: date),
            month: dependency.calculator.month(from: date),
            day: dependency.calculator.day(from: date)
        )
        guard let targetDate,
              let nextDate = dependency.calculator.date(byAddingDayValue: 1, to: targetDate)
        else {
            return []
        }
        let items = dependency.todoUseCase.fetch(start: targetDate, end: nextDate)
            .sorted(by: { $0.createAt > $1.createAt })
            .map { CalendarItem(
                model: CalendarListTableViewCellModel(text: $0.todo, isComplete: $0.isComplete),
                createdAt: $0.createAt
            )}
        if items.isEmpty {
            return []
        } else {
            return [.content(items)]
        }
    }
    
}
