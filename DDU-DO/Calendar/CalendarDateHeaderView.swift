//
//  CalendarDateHeaderView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit
import SnapKit
import JTAppleCalendar

final class CalendarDateHeaderView: JTACMonthReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String) {
        self.monthLabel.text = title
    }
    
    private func setupLayout() {
        self.addSubview(self.weekStackView)
        self.weekStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
        self.weekLabel.forEach { self.weekStackView.addArrangedSubview($0) }
        
        self.addSubview(self.monthLabel)
        self.monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(self.weekStackView.snp.top).offset(-5)
        }
    }
    
    private func setupAttributes() {
        self.weekLabel.enumerated().forEach {
            switch $0.offset {
            case 0:         $0.element.textColor = .red
            case 6:         $0.element.textColor = .blue
            default:        $0.element.textColor = .black
            }
            $0.element.text = self.week[safe: $0.offset]
            $0.element.textAlignment = .center
            $0.element.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        self.weekStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        self.monthLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 21, weight: .bold)
        }
    }
    
    private let week = ["일", "월", "화", "수", "목", "금", "토"]
    private lazy var weekLabel: [UILabel] = {
        self.week.map { _ -> UILabel in
            return UILabel(frame: .zero)
        }
    }()
    private let monthLabel = UILabel(frame: .zero)
    private let weekStackView = UIStackView(frame: .zero)
    
}
