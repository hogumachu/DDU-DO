//
//  TodoDetailContentView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/09.
//

import UIKit
import SnapKit
import Then

struct TodoDetailContentViewModel {
    
    let imageName: String
    let title: String
    
}

final class TodoDetailContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: TodoDetailContentViewModel) {
        self.imageView.image = UIImage(systemName: model.imageName)
        self.titleLabel.text = model.title
    }
    
    private func setupLayout() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        self.titleLabel.do {
            $0.font = .systemFont(ofSize: 17)
            $0.numberOfLines = 1
        }
    }
    
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    
}
