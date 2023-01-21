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
        self.addSubview(self.monthLabel)
        self.monthLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.monthLabel.do {
            $0.font = .systemFont(ofSize: 15, weight: .bold)
        }
    }
    
    private let monthLabel = UILabel(frame: .zero)
    
}
