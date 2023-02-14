//
//  CalendarListEmptyView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

final class CalendarListEmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview()
        }
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.contentLabel)
    }
    
    private func setupAttributes() {
        self.stackView.do {
            $0.axis = .vertical
            $0.spacing = 3
        }
        
        self.titleLabel.do {
            $0.text = "저장된 내용이 없어요"
            $0.textColor = .lightBlue
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.numberOfLines = 0
        }
        
        self.contentLabel.do {
            $0.text = "하단에 있는 버튼으로 추가할 수 있어요"
            $0.textColor = .lightBlue
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.numberOfLines = 0
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let stackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    
}
