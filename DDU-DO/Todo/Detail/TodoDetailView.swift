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
    func todoDetailViewDidTapSaveButton(_ view: TodoDetailView)
    func todoDetailViewDidTapCancelButton(_ view: TodoDetailView)
    
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
        self.addSubview(self.buttonStackView)
        self.buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.buttonStackView.addArrangedSubview(self.cancelButton)
        self.buttonStackView.addArrangedSubview(self.saveButton)
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.buttonStackView.snp.top)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .white
        
        self.contentLabel.do {
            $0.text = self.delegate?.todo
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        
        self.buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fillEqually
        }
        
        self.cancelButton.do {
            $0.backgroundColor = .red
            $0.addTarget(self, action: #selector(cancelButtonDidTap(_:)), for: .touchUpInside)
        }
        
        self.saveButton.do {
            $0.backgroundColor = .blue
            $0.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func cancelButtonDidTap(_ sender: UIButton) {
        self.delegate?.todoDetailViewDidTapCancelButton(self)
    }
    
    @objc private func saveButtonDidTap(_ sender: UIButton) {
        self.delegate?.todoDetailViewDidTapSaveButton(self)
    }
    
    private let buttonStackView = UIStackView(frame: .zero)
    
    private let contentLabel = UILabel(frame: .zero)
    private let cancelButton = UIButton(frame: .zero)
    private let saveButton = UIButton(frame: .zero)
    
}
