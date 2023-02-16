//
//  SettingTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/15.
//

import UIKit
import SnapKit
import Then

struct SettingTableViewCellModel {
    
    let title: String?
    let subtitle: String?
    
}

final class SettingTableViewCell: UITableViewCell {
    
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
        self.titleLabel.text = nil
        self.subtitleLabel.text = nil
    }
    
    func configure(_ model: SettingTableViewCellModel) {
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.subtitle
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            make.height.equalTo(50)
        }
        
        self.containerView .addSubview(self.rightImageView)
        self.rightImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        self.containerView.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.rightImageView.snp.leading).offset(-20)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
        }
        
        self.titleLabel.do {
            $0.textColor = .blueBlack
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        self.subtitleLabel.do {
            $0.textColor = .green1
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        self.rightImageView.do {
            $0.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .blueBlack
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let rightImageView = UIImageView(frame: .zero)
    
}
