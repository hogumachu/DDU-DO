//
//  Toast.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/31.
//

import UIKit

struct ToastModel {
    
    let message: String
    let type: ToastType
    
    init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }
    
}

enum ToastType {
    
    case normal
    case success
    case fail
    
}

final class Toast: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: ToastModel) {
        self.messageLabel.text = model.message
        
        switch model.type {
        case .normal:
            self.imageView.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = .white
            
        case .success:
            self.imageView.image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = .systemGreen
            
        case .fail:
            self.imageView.image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = .systemRed
        }
        
        self.containerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.leading.bottom.equalToSuperview()
        }
        
        self.containerView.addSubview(self.messageLabel)
        self.messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.imageView.snp.trailing).offset(5)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.do {
            $0.clipsToBounds = true
            $0.backgroundColor = .black.withAlphaComponent(0.7)
            $0.layer.cornerRadius = 8
        }
        
        self.imageView.do {
            $0.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .white
        }
        
        self.messageLabel.do {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 13, weight: .semibold)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    
}
