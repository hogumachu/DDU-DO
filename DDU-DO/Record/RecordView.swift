//
//  RecordView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/28.
//

import UIKit
import SnapKit
import Then

protocol RecordViewDelegate: AnyObject {
    
    func recordView(_ view: RecordView, didUpdateText text: String)
    func recordViewDidTapRecordButton(_ view: RecordView, text: String)
    
}

final class RecordView: UIView {
    
    weak var delegate: RecordViewDelegate?
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        self.recordInputView.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        self.recordInputView.resignFirstResponder()
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
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.recordButton)
        self.recordButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        self.containerView.addSubview(self.recordInputView)
        self.recordInputView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.recordButton.snp.top)
            make.height.equalTo(80)
        }
    }
    
    private func setupAttributes() {
        self.containerView.backgroundColor = .white
        self.recordInputView.do {
            $0.delegate = self
        }
        
        self.recordButton.do {
            $0.layer.cornerRadius = 60 / 2
            $0.backgroundColor = .systemBlue
            $0.addTarget(self, action: #selector(recordButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func recordButtonDidTap(_ sender: UIButton) {
        self.delegate?.recordViewDidTapRecordButton(self, text: self.recordInputView.text ?? "")
    }
    
    private let containerView = UIView(frame: .zero)
    private let recordInputView = RecordInputView(frame: .zero)
    private let recordButton = UIButton(frame: .zero)
    
}

extension RecordView: RecordInputViewDelegate {
    
    func recordInputView(_ view: RecordInputView, didUpdateText text: String) {
        self.delegate?.recordView(self, didUpdateText: text)
    }
    
}
