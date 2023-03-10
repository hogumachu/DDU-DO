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
    func todoDetailViewDidUpdateText(_ view: TodoDetailView, text: String)
    func todoDetailViewDidTapEdit(_ view: TodoDetailView, text: String?)
    func todoDetailViewDidTapRemove(_ view: TodoDetailView)
    func todoDetailViewDidTapQuickChange(_ view: TodoDetailView)
    
}

final class TodoDetailView: UIView {
    
    weak var delegate: TodoDetailViewDelegate? {
        didSet {
            self.textInputView.text = self.delegate?.todo
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
    
    func updateEditButtonState(isEnabled: Bool) {
        self.editButton.isEnabled = isEnabled
        self.editButton.backgroundColor = isEnabled ? .green2 : .systemGray
    }
    
    private func setupLayout() {
        self.addSubview(self.editButton)
        self.editButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        self.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.editButton.snp.top).offset(-20)
        }
        
        self.contentStackView.addArrangedSubview(self.removeView)
        self.contentStackView.addArrangedSubview(self.quickChangeView)
        
        self.addSubview(self.textInputView)
        self.textInputView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.contentStackView.snp.top).offset(-10)
            make.height.equalTo(50)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        
        self.textInputView.do {
            $0.text = self.delegate?.todo
            $0.delegate = self
        }
        
        self.contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        self.removeView.do {
            $0.configure(.init(imageName: "trash.square.fill", title: "삭제하기"))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeViewDidTap))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.quickChangeView.do {
            $0.configure(.init(imageName: "arrow.forward.square.fill", title: "다음날로 미루기"))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quickChangeViewDidTap))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.editButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .green2
            $0.setTitle("변경하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.gray2, for: .disabled)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(editViewDidTap(_:)), for: .touchUpInside)
        }
        
        self.updateEditButtonState(isEnabled: false)
    }
    
    @objc private func editViewDidTap(_ sender: UIButton) {
        self.delegate?.todoDetailViewDidTapEdit(self, text: self.textInputView.text)
    }
    
    @objc private func removeViewDidTap(_ sender: UIView) {
        self.delegate?.todoDetailViewDidTapRemove(self)
    }
    
    @objc private func quickChangeViewDidTap(_ sender: UIView) {
        self.delegate?.todoDetailViewDidTapQuickChange(self)
    }
    
    private let contentStackView = UIStackView(frame: .zero)
    
    private let textInputView = TextInputView(frame: .zero)
    private let removeView = TodoDetailContentView(frame: .zero)
    private let quickChangeView = TodoDetailContentView(frame: .zero)
    private let editButton = UIButton(frame: .zero)
    
}

extension TodoDetailView: TextInputViewDelegate {
    
    func textInputView(_ view: TextInputView, didUpdateText text: String) {
        self.delegate?.todoDetailViewDidUpdateText(self, text: text)
    }
    
    func textInputViewDidReturn(_ view: TextInputView) {
        self.delegate?.todoDetailViewDidTapEdit(self, text: self.textInputView.text)
    }
    
}
