//
//  CalendarDateBadgeView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

final class CalendarDateBadgeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(count: Int) {
        self.isHidden = false
        
        switch count {
        case 0:
            self.numberLabel.text = "0"
            self.isHidden = true
            
        case 1:
            self.numberLabel.text = "1"
            self.containerView.backgroundColor = .darkGray
            
        case 2:
            self.numberLabel.text = "2"
            self.containerView.backgroundColor = .systemOrange
            
        default:
            self.numberLabel.text = "3+"
            self.containerView.backgroundColor = .systemPink
            
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.layer.cornerRadius = 3
            $0.backgroundColor = .darkGray
        }
        
        self.numberLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 10, weight: .regular)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let numberLabel = UILabel(frame: .zero)
    
}
