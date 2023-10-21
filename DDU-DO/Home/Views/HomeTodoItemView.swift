//
//  HomeTodoItemView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/13.
//

import UIKit
import SnapKit
import Then

protocol HomeTodoItemViewDelegate: AnyObject {
    
    func homeTodoItemViewDidSelect(_ view: HomeTodoItemView, tag: Int)
    func homeTodoItemViewDidSelectComplete(_ view: HomeTodoItemView, tag: Int)
    
}

struct HomeTodoItemViewModel {
    
    let text: String?
    let isComplete: Bool
    let createdAt: Date
    
    init(entity: TodoEntity) {
        self.text = entity.todo
        self.isComplete = entity.isComplete
        self.createdAt = entity.createAt
    }
    
}

final class HomeTodoItemView: UIView {
    
    weak var delegate: HomeTodoItemViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: HomeTodoItemViewModel, type: HomeTodoType) {
        if model.isComplete {
            self.contentLabel.attributedText = NSMutableAttributedString(string: model.text ?? "")
                .strikethrough()
            self.containerView.backgroundColor = .gray2
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
            self.checkImageView.image = .init(systemName: "checkmark", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        } else {
            self.contentLabel.attributedText = NSMutableAttributedString(string: model.text ?? "")
            self.containerView.backgroundColor = .gray0
            self.checkImageView.image = nil
        }
        
        switch type {
        case .today:
            self.checkImageView.isHidden = false
            self.contentLabelTrailgConstraint?.update(offset: -65)
            
        case .etc:
            self.contentLabel.attributedText = NSMutableAttributedString(string: model.text ?? "")
            self.checkImageView.isHidden = true
            self.contentLabelTrailgConstraint?.update(offset: -20)
            self.containerView.backgroundColor = .gray0
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(55)
        }
        
        self.containerView.addSubview(self.checkImageView)
        self.checkImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.containerView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            self.contentLabelTrailgConstraint = make.trailing.equalToSuperview().offset(-65).constraint
        }
    }
    
    private func setupAttributes() {
        self.containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.contentLabel.do {
            $0.textColor = .blueBlack
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        self.checkImageView.do {
            $0.backgroundColor = .gray1
            $0.layer.cornerRadius = 10
            $0.contentMode = .center
            $0.tintColor = .green2
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkImageViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func containerViewDidTap(_ sender: UIGestureRecognizer) {
        self.delegate?.homeTodoItemViewDidSelect(self, tag: self.tag)
    }
    
    @objc private func checkImageViewDidTap(_ sender: UIGestureRecognizer) {
        self.delegate?.homeTodoItemViewDidSelectComplete(self, tag: self.tag)
    }
    
    private var contentLabelTrailgConstraint: Constraint?
    
    private let containerView = UIView(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    private let checkImageView = UIImageView(frame: .zero)
    
}
