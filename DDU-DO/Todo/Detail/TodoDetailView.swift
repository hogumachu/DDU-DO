//
//  TodoDetailView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/30.
//

import UIKit
import SnapKit
import Then

protocol TodoDetailViewDelegate: AnyObject {
    
    var todo: String? { get }
    func todoDetailViewDidTapEdit(_ view: TodoDetailView)
    func todoDetailViewDidTapRemove(_ view: TodoDetailView)
    func todoDetailViewDidTapQuickChange(_ view: TodoDetailView)
    
}

final class TodoDetailView: UIView {
    
    weak var delegate: TodoDetailViewDelegate? {
        didSet {
            self.contentLabel.text = self.delegate?.todo
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.contentStackView.addArrangedSubview(self.editView)
        self.contentStackView.addArrangedSubview(self.removeView)
        self.contentStackView.addArrangedSubview(self.quickChangeView)
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.contentStackView.snp.top)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        
        self.contentLabel.do {
            $0.text = self.delegate?.todo
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 3
            $0.distribution = .fillEqually
        }
        
        self.editView.do {
            $0.configure(.init(imageName: "pencil.circle.fill", title: "수정하기"))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editViewDidTap))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.removeView.do {
            $0.configure(.init(imageName: "trash.circle.fill", title: "삭제하기"))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeViewDidTap))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.quickChangeView.do {
            $0.configure(.init(imageName: "calendar.circle.fill", title: "날짜 변경하기"))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quickChangeViewDidTap))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func editViewDidTap(_ sender: UIView) {
        self.delegate?.todoDetailViewDidTapEdit(self)
    }
    
    @objc private func removeViewDidTap(_ sender: UIButton) {
        self.delegate?.todoDetailViewDidTapRemove(self)
    }
    
    @objc private func quickChangeViewDidTap(_ sender: UIButton) {
        self.delegate?.todoDetailViewDidTapQuickChange(self)
    }
    
    private let contentStackView = UIStackView(frame: .zero)
    
    private let contentLabel = UILabel(frame: .zero)
    private let editView = TodoDetailContentView(frame: .zero)
    private let removeView = TodoDetailContentView(frame: .zero)
    private let quickChangeView = TodoDetailContentView(frame: .zero)
    
}
