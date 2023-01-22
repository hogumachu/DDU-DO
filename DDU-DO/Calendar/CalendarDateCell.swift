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
        self.containerView.backgroundColor = .white
    }
    
    func configure(_ state: CellState) {
        self.dateLabel.text = state.text
        self.dateLabel.textColor = state.dateBelongsTo == .thisMonth ? .black : .gray
        self.containerView.backgroundColor = state.isSelected ? .systemPink : .white
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
        }
        
        self.dateLabel.do {
            $0.font = .systemFont(ofSize: 13, weight: .regular)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    
}
