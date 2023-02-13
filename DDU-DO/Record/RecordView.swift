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
    
    var dateString: String? { get }
    var weekday: Weekday? { get }
    func recordView(_ view: RecordView, didUpdateText text: String)
    func recordViewDidTapRecordButton(_ view: RecordView, text: String)
    func recordViewDidReturn(_ view: RecordView, text: String)
    
}

final class RecordView: UIView {
    
    weak var delegate: RecordViewDelegate? {
        didSet {
            self.updateDelegate()
        }
    }
    
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
    
    private func updateDelegate() {
        self.dateLabel.text = self.delegate?.dateString
        self.weekdayLabel.text = self.delegate?.weekday?.toString()
        
        switch self.delegate?.weekday {
        case .sunday:
            self.weekdayLabel.textColor = .red
            
        case .saturday:
            self.weekdayLabel.textColor = .blue
            
        default:
            self.weekdayLabel.textColor = .purple4
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.recordButton)
        self.recordButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        self.containerView.addSubview(self.recordInputView)
        self.recordInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.recordButton.snp.top).offset(-10)
            make.height.equalTo(50)
        }
        
        self.containerView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(self.recordInputView.snp.top).offset(-10)
        }
        
        self.containerView.addSubview(self.weekdayContainerView)
        self.weekdayContainerView.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateLabel)
            make.leading.equalTo(self.dateLabel.snp.trailing).offset(5)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        self.weekdayContainerView.addSubview(self.weekdayLabel)
        self.weekdayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.containerView.backgroundColor = .purple4
        
        self.dateLabel.do {
            $0.textColor = .lightPurple
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        self.weekdayContainerView.do {
            $0.backgroundColor = .lightPurple
            $0.layer.cornerRadius = 4
        }
        self.weekdayLabel.do {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
        }
       
        self.recordInputView.do {
            $0.delegate = self
        }
        
        self.recordButton.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .purple1
            $0.setTitle("저장하기", for: .normal)
            $0.setTitleColor(.lightPurple, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(recordButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func recordButtonDidTap(_ sender: UIButton) {
        self.delegate?.recordViewDidTapRecordButton(self, text: self.recordInputView.text ?? "")
    }
    
    private let weekdayContainerView = UIView(frame: .zero)
    private let weekdayLabel = UILabel(frame: .zero)
    private let dateLabel = UILabel(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let recordInputView = TextInputView(frame: .zero)
    private let recordButton = UIButton(frame: .zero)
    
}

extension RecordView: TextInputViewDelegate {
    
    func textInputView(_ view: TextInputView, didUpdateText text: String) {
        self.delegate?.recordView(self, didUpdateText: text)
    }
    
    func textInputViewDidReturn(_ view: TextInputView) {
        self.delegate?.recordViewDidReturn(self, text: self.recordInputView.text ?? "")
    }
    
}
