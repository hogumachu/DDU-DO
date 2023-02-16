//
//  TextOnlyTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then

struct TextOnlyTableViewCellModel {
    let text: String
    let textColor: UIColor?
    let backgroundColor: UIColor?
    let font: UIFont?
    
    init(text: String, textColor: UIColor? = .black, backgroundColor: UIColor? = .white, font: UIFont? = .systemFont(ofSize: 12)) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.font = font
    }
}

final class TextOnlyTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: TextOnlyTableViewCellModel, inset: UIEdgeInsets = .zero) {
        self.titleLabel.do {
            $0.text = model.text
            $0.textColor = model.textColor
            $0.font = model.font
        }
        
        self.backgroundColor = model.backgroundColor
        
        self.titleLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
    private func setupLabel() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLabel.do {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
        }
    }
    
    private let titleLabel = UILabel(frame: .zero)
    
}
