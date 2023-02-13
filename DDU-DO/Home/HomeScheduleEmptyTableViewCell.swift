//
//  HomeScheduleEmptyTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/13.
//

import UIKit
import SnapKit
import Then

final class HomeScheduleEmptyTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            make.height.equalTo(40)
        }
        
        self.containerView.addSubview(self.plusImageView)
        self.plusImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.containerView.do {
            $0.backgroundColor = .systemPink
            $0.layer.cornerRadius = 10
        }
        
        self.plusImageView.do {
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
            $0.image = UIImage(systemName: "plus", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let plusImageView = UIImageView(frame: .zero)
    
}
