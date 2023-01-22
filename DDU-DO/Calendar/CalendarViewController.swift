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

final class CalendarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalendarView()
    }
    
    private func setupCalendarView() {
        self.view.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40 * 7)
        }
        
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.backgroundColor = .white
    }
    
    private let calendarView = CalendarView(frame: .zero)
    
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
        return MonthSize(defaultSize: 30)
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
