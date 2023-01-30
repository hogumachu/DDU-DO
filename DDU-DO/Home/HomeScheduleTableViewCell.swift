//
//  HomeScheduleTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then

struct HomeScheduleTableViewCellModel {
    let text: String?
}

final class HomeScheduleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.scheduleLabel.text = nil
    }
    
    func configure(_ model: HomeScheduleTableViewCellModel) {
        self.scheduleLabel.text = model.text
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.scheduleLabel)
        self.scheduleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        
        self.scheduleLabel.do {
            $0.textColor = .black
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
    }
    
    private let scheduleLabel = UILabel(frame: .zero)
    
}
