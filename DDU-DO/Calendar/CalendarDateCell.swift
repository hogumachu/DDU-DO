//
//  CalendarDateCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import JTAppleCalendar

struct CalendarDateCellModel {
    
    let state: CellState
    let numberOfItems: Int
    
}

final class CalendarDateCell: JTACDayCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.textColor = .black
        self.circleView.backgroundColor = .white
        self.badgeView.configure(count: 0)
    }
    
    func configure(_ model: CalendarDateCellModel) {
        self.dateLabel.text = model.state.text
        self.circleView.backgroundColor = model.state.isSelected ? .systemPink : .white
        switch model.state.day {
        case .sunday:
            self.dateLabel.textColor = .red
        case .saturday:
            self.dateLabel.textColor = .blue
        default:
            self.dateLabel.textColor = .black
        }
        
        if model.state.dateBelongsTo != .thisMonth {
            self.dateLabel.textColor = .gray
            self.badgeView.configure(count: 0)
        } else {
            self.badgeView.configure(count: model.numberOfItems)
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.circleView)
        self.circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        self.containerView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.containerView.addSubview(self.badgeView)
        self.badgeView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.backgroundColor = .white
        }
        
        self.circleView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25 / 2
        }
        
        self.dateLabel.do {
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let circleView = UIView(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let badgeView = CalendarDateBadgeView(frame: .zero)
    
}
