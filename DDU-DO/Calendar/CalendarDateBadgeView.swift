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
        case 0:     self.isHidden = true
        case 1:     self.containerView.backgroundColor = .pink1
        case 2:     self.containerView.backgroundColor = .pink2
        default:    self.containerView.backgroundColor = .pink3
            
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 8, height: 8))
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.layer.cornerRadius = 4
        }
    }
    
    private let containerView = UIView(frame: .zero)
    
}
