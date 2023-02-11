//
//  TodoDetailViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

protocol TodoDetailViewControllerDelegate: AnyObject {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String)
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String)
    
}

final class TodoDetailViewController: UIViewController {
    
    weak var delegate: TodoDetailViewControllerDelegate?
    
    init(viewModel: TodoDetailViewModel) {
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
    
    func presentWithAnimation(from viewController: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        
        viewController.present(self, animated: false) {
            self.detailViewTopConstraint?.isActive = false
            self.detailViewBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.backgroundColor = .black.withAlphaComponent(0.4)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func bind(_ viewModel: TodoDetailViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: TodoDetailViewModelEvent) {
        switch event {
        case .updateEditButtonState(let isEnabled):
            self.detailView.updateEditButtonState(isEnabled: isEnabled)
            
        case .didFinish(let message):
            self.dismissWithAnimation {
                self.delegate?.todoDetailViewControllerDidFinish(self, message: message)
            }
            
        case .didFail(let message):
            self.dismissWithAnimation {
                self.delegate?.todoDetailViewControllerDidFail(self, message: message)
            }
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.detailViewTopConstraint = make.top.equalTo(self.view.snp.bottom).constraint
            self.detailViewBottomConstraint = make.bottom.equalTo(self.view.snp.bottom).constraint
        }
        
        self.detailViewBottomConstraint?.isActive = false
    }
    
    private func setupAttributes() {
        self.backgroundView.do {
            $0.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.detailView.do {
            $0.delegate = self
        }
    }
    
    private func dismissWithAnimation(completion: (() -> Void)? = nil) {
        self.detailViewTopConstraint?.isActive = true
        self.detailViewBottomConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
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
        
        self.detailViewBottomConstraint?.update(offset: -keyboardSize.height)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.detailViewBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func backgroundViewDidTap(_ sender: UIView) {
        self.dismissWithAnimation()
    }
    
    private var detailViewTopConstraint: Constraint?
    private var detailViewBottomConstraint: Constraint?
    
    private let backgroundView = UIView(frame: .zero)
    private let detailView = TodoDetailView(frame: .zero)
    private let viewModel: TodoDetailViewModel
    private let disposeBag = DisposeBag()
    
}

extension TodoDetailViewController: TodoDetailViewDelegate {
    
    var todo: String? {
        self.viewModel.todo
    }
    
    func todoDetailViewDidUpdateText(_ view: TodoDetailView, text: String) {
        self.viewModel.updateText(text: text)
    }
    
    func todoDetailViewDidTapEdit(_ view: TodoDetailView, text: String?) {
        self.viewModel.didTapEdit(text: text)
    }
    
    func todoDetailViewDidTapRemove(_ view: TodoDetailView) {
        self.viewModel.didTapRemove()
    }
    
    func todoDetailViewDidTapQuickChange(_ view: TodoDetailView) {
        self.viewModel.didTapQuickChange()
    }
    
}
