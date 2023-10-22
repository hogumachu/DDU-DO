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
    
    func reloadData() {
        self.monthView.reloadData()
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
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        self.insertSubview(self.containerShadowView, belowSubview: self.containerView)
        self.containerShadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }
        
        self.containerView.addSubview(self.monthView)
        self.monthView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .gray0
        
        self.containerView.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = 16
        }
        
        self.containerShadowView.do {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = false
            $0.backgroundColor = .gray0
            $0.applyShadow(
                color: .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: -4),
                blur: 16
            )
        }
        
        self.monthView.do {
            $0.backgroundColor = .gray0
            $0.registerCell(cell: CalendarDateCell.self)
            $0.scrollDirection = .horizontal
            $0.scrollingMode = .stopAtEachCalendarFrame
            $0.showsHorizontalScrollIndicator = false
            $0.allowsMultipleSelection = false
            $0.allowsRangedSelection = false
        }
    }
    
    private let containerShadowView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let monthView = JTACMonthView(frame: .zero)
    
}
