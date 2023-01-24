//
//  CalendarViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import JTAppleCalendar
import RxSwift

final class CalendarViewController: UIViewController {
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupLayout()
        self.setupAttributes()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: CalendarViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: CalendarViewModelEvent) {
        switch event {
        case .reloadData:
            self.calendarListView.reloadData()
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35 * 7)
        }
        
        self.view.addSubview(self.calendarListView)
        self.calendarListView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.calendarView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
        }
        
        self.calendarListView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
        }
    }
    
    private let calendarView = CalendarView(frame: .zero)
    private let calendarListView = CalendarListView(frame: .zero)
    private let viewModel: CalendarViewModel
    private let disposeBag = DisposeBag()
    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableCell(cell: CalendarDateCell.self, for: indexPath) else {
            return JTACDayCell()
        }
        cell.configure(cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
        self.viewModel.didSelectDate(date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return cellState.dateBelongsTo == .thisMonth
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        guard let view = calendar.dequeueReusableView(view: CalendarDateHeaderView.self, for: indexPath) else { return JTACMonthReusableView() }
        let formatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월"
            $0.locale = Locale(identifier: "ko_kr")
        }
        view.configure(formatter.string(from: range.start))
        return view
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 60)
    }
    
}

extension CalendarViewController: CalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter().then {
            $0.dateFormat = "yyyy MM dd"
            $0.locale = Locale(identifier: "ko_kr")
        }
        let startDate = formatter.date(from: "2022 12 01")!
        let endDate = Date()
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            generateInDates: .forFirstMonthOnly,
            generateOutDates: .tillEndOfRow,
            hasStrictBoundaries: true
        )
    }
    
}

extension CalendarViewController: CalendarListViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(at: indexPath)
    }
    
}

extension CalendarViewController: CalendarListViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.cellItem(at: indexPath) else { return UITableViewCell() }
        
        switch item {
        case .content(let model):
            guard let cell = tableView.dequeueReusableCell(cell: CalendarListTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            cell.configure(model)
            return cell
        }
    }
    
}
