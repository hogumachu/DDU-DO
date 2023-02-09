//
//  RecordInputView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/28.
//

import UIKit
import SnapKit
import Then

protocol RecordInputViewDelegate: AnyObject {
    
    func recordInputView(_ view: RecordInputView, didUpdateText text: String)
    func recordInputViewDidReturn(_ view: RecordInputView)
    
}

final class RecordInputView: UIView {
    
    weak var delegate: RecordInputViewDelegate?
    
    var text: String? {
        self.textField.text
    }
    
    override func becomeFirstResponder() -> Bool {
        self.textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.textField.resignFirstResponder()
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
        self.addSubview(self.textFieldContainerView)
        self.textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        self.textFieldContainerView.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    private func setupAttributes() {
        self.textFieldContainerView.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
        }
        
        self.textField.do {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChangeText(_ textField: UITextField) {
        self.delegate?.recordInputView(self, didUpdateText: textField.text ?? "")
    }
    
    private let textFieldContainerView = UIView(frame: .zero)
    private let textField = UITextField(frame: .zero)
    
}

extension RecordInputView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Do Something
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Do Something
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.recordInputViewDidReturn(self)
        return textField.resignFirstResponder()
    }
    
}
