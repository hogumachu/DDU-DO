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
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
        
        self.contentView.insertSubview(self.containerShadowView, belowSubview: self.containerView)
        self.containerShadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }
        
        self.containerView.addSubview(self.completeButton)
        self.completeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 25))
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.containerView.addSubview(self.scheduleLabel)
        self.scheduleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
            make.trailing.equalTo(self.completeButton.snp.leading).offset(-10)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        
        self.containerShadowView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = false
            $0.applyShadow(color: .black, opacity: 0.05, offset: CGSize(width: 2, height: 4), blur: 4)
        }
        
        self.scheduleLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.lineBreakMode = .byCharWrapping
            $0.numberOfLines = 0
        }
        
        self.completeButton.do {
            $0.setTitle("완료하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemPink
            $0.layer.cornerRadius = 6
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let containerShadowView = UIView(frame: .zero)
    private let scheduleLabel = UILabel(frame: .zero)
    private let completeButton = UIButton(frame: .zero)
    
}
