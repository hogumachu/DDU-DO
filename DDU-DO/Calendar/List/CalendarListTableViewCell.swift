//
//  CalendarListTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/24.
//

import UIKit
import SnapKit
import Then

struct CalendarListTableViewCellModel {
    
    let text: String?
    
}

final class CalendarListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentLabel.text = nil
    }
    
    func configure(_ model: CalendarListTableViewCellModel) {
        self.contentLabel.text = model.text
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
//        self.containerView.do {
//            
//        }
        
        self.contentLabel.do {
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    
}
