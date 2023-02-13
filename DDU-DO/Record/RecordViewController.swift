//
//  RecordViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/28.
//

import UIKit
import SnapKit
import Then
import RxSwift

protocol RecordViewControllerDelegate: AnyObject {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date)
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String)
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController)
    
}

final class RecordViewController: UIViewController {
    
    weak var delegate: RecordViewControllerDelegate?
    
    init(viewModel: RecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupLayout()
        self.setupAttributes()
        self.setupKeyboardNotification()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.recordView.maskRoundedRect(cornerRadius: 20, corners: [.topLeft, .topRight])
    }
    
    func presentWithAnimation(from viewController: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        
        viewController.present(self, animated: false) {
            self.recordViewTopConstraint?.isActive = false
            self.recordViewBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.backgroundColor = .black.withAlphaComponent(0.4)
                self.recordView.becomeFirstResponder()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func dismissWithAnimation(completion: (() -> Void)? = nil) {
        self.recordViewTopConstraint?.isActive = true
        self.recordViewBottomConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = .clear
            self.recordView.resignFirstResponder()
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    private func bind(_ viewModel: RecordViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: RecordViewModelEvent) {
        switch event {
        case .didFinishRecord(let targetDate):
            self.dismissWithAnimation {
                self.delegate?.recordViewControllerDidFinishRecord(self, targetDate: targetDate)
            }
            
        case .didFailRecord(let message):
            self.dismissWithAnimation {
                self.delegate?.recordViewControllerDidFailRecord(self, message: message)
            }
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.recordView)
        self.recordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.recordViewTopConstraint = make.top.equalTo(self.view.snp.bottom).constraint
            self.recordViewBottomConstraint = make.bottom.equalTo(self.view.snp.bottom).constraint
        }
        self.recordViewBottomConstraint?.isActive = false
    }
    
    private func setupAttributes() {
        self.backgroundView.do {
            $0.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.recordView.do {
            $0.delegate = self
        }
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.recordViewBottomConstraint?.update(offset: -keyboardSize.height)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.recordViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func backgroundViewDidTap(_ sender: UIView) {
        self.dismissWithAnimation {
            self.delegate?.recordViewControllerDidCancelRecord(self)
        }
    }
    
    private var recordViewTopConstraint: Constraint?
    private var recordViewBottomConstraint: Constraint?
    
    private let backgroundView = UIView(frame: .zero)
    private let recordView = RecordView(frame: .zero)
    private let viewModel: RecordViewModel
    private let disposeBag = DisposeBag()
    
}

extension RecordViewController: RecordViewDelegate {
    
    var dateString: String? {
        self.viewModel.dateString
    }
    
    var weekday: Weekday? {
        self.viewModel.weekday
    }
    
    func recordView(_ view: RecordView, didUpdateText text: String) {
        
    }
    
    func recordViewDidTapRecordButton(_ view: RecordView, text: String) {
        self.viewModel.record(text)
    }
    
    func recordViewDidReturn(_ view: RecordView, text: String) {
        self.viewModel.record(text)
    }
    
}
