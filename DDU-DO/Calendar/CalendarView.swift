//
//  CalendarView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import JTAppleCalendar

typealias CalendarViewDelegate = JTACMonthViewDelegate
typealias CalendarViewDataSource = JTACMonthViewDataSource

final class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate? {
        didSet { self.monthView.calendarDelegate = self.delegate }
    }
    
    weak var dataSource: CalendarViewDataSource? {
        didSet { self.monthView.calendarDataSource = self.dataSource }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(date: Date) {
        UIView.performWithoutAnimation {
            self.monthView.reloadData(withAnchor: date, completionHandler: nil)
        }
    }
    
    func scrollToDate(_ date: Date, animated: Bool = false) {
        self.monthView.scrollToDate(date, animateScroll: animated)
    }
    
    func selectDate(_ date: Date) {
        self.monthView.selectDates([date])
    }
    
    private func setupLayout() {
        self.addSubview(self.monthView)
        self.monthView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.monthView.do {
            $0.registerCell(cell: CalendarDateCell.self)
            $0.registerReusableView(view: CalendarDateHeaderView.self)
            $0.scrollDirection = .horizontal
            $0.scrollingMode = .stopAtEachCalendarFrame
            $0.showsHorizontalScrollIndicator = false
            $0.allowsMultipleSelection = false
            $0.allowsRangedSelection = false
        }
    }
    
    private let monthView = JTACMonthView(frame: .zero)
    
}
