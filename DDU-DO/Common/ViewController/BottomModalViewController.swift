//
//  BottomModalViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/16.
//

import UIKit
import SnapKit
import Then

protocol BottomModalViewControllerDelegate: AnyObject {
    
    func bottomModalViewControllerDidTapButton(_ viewController: BottomModalViewController)
    func bottomModalViewControllerDidTapCancelButton(_ viewController: BottomModalViewController)
    func bottomModalViewControllerDidTapBackground(_ viewController: BottomModalViewController)
    
}

extension BottomModalViewControllerDelegate {
    
    func bottomModalViewControllerDidTapCancelButton(_ viewController: BottomModalViewController) {}
    func bottomModalViewControllerDidTapBackground(_ viewController: BottomModalViewController) {}
    
}

struct BottomModalViewModel {
    
    let title: String
    let subtitle: String
    let buttonTitle: String
    let cancelButtonTitle: String
    let type: BottomModalViewType
    
}

enum BottomModalViewType {
    
    case normal
    case alert
    
    var buttonTitleColor: UIColor? {
        switch self {
        case .normal:       return .white
        case .alert:        return .white
        }
    }
    
    var buttonBackgroundColor: UIColor? {
        switch self {
        case .normal:       return .green2
        case .alert:        return .systemRed
        }
    }
    
}

final class BottomModalViewController: UIViewController {
    
    weak var delegate: BottomModalViewControllerDelegate?
    
    init(viewModel: BottomModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.maskRoundedRect(cornerRadius: 20, corners: [.topLeft, .topRight])
    }
    
    func presentWithAnimation(from viewController: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        
        viewController.present(self, animated: false) {
            self.containerViewTopConstraint?.isActive = false
            self.containerViewBottomConstriant?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.backgroundColor = .black.withAlphaComponent(0.4)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func dismissWithAnimation(completion: (() -> Void)? = nil) {
        self.containerViewTopConstraint?.isActive = true
        self.containerViewBottomConstriant?.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = .clear
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.containerViewTopConstraint = make.top.equalTo(self.view.snp.bottom).constraint
            self.containerViewBottomConstriant = make.bottom.equalTo(self.view.snp.bottom).constraint
        }
        self.containerViewBottomConstriant?.isActive = false
        
        self.containerView.addSubview(self.buttonStackView)
        self.buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-UIScreen.bottomSafeAreaInset - 10)
        }
        
        self.buttonStackView.addArrangedSubview(self.cancelButton)
        self.buttonStackView.addArrangedSubview(self.button)
        
        self.containerView.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.buttonStackView.snp.top).offset(-20)
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.subtitleLabel.snp.top).offset(-5)
        }
    }
    
    private func setupAttributes() {
        self.backgroundView.do {
            $0.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.containerView.do {
            $0.backgroundColor = .white
        }
        
        self.titleLabel.do {
            $0.text = self.viewModel.title
            $0.textColor = .blueBlack
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.subtitleLabel.do {
            $0.text = self.viewModel.subtitle
            $0.textColor = .green1
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        self.buttonStackView.do {
            $0.spacing = 5
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        self.cancelButton.do {
            $0.layer.cornerRadius = 16
            $0.setTitle(self.viewModel.cancelButtonTitle, for: .normal)
            $0.backgroundColor = .gray1
            $0.setTitleColor(.green2, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(cancelButtonDidTap(_:)), for: .touchUpInside)
        }
        
        self.button.do {
            $0.layer.cornerRadius = 16
            $0.setTitle(self.viewModel.buttonTitle, for: .normal)
            $0.backgroundColor = self.viewModel.type.buttonBackgroundColor
            $0.setTitleColor(self.viewModel.type.buttonTitleColor, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func backgroundViewDidTap(_ sender: UIView) {
        self.dismissWithAnimation {
            self.delegate?.bottomModalViewControllerDidTapBackground(self)
        }
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        self.dismissWithAnimation {
            self.delegate?.bottomModalViewControllerDidTapButton(self)
        }
    }
    
    @objc private func cancelButtonDidTap(_ sender: UIButton) {
        self.dismissWithAnimation {
            self.delegate?.bottomModalViewControllerDidTapCancelButton(self)
        }
    }
    
    private var containerViewTopConstraint: Constraint?
    private var containerViewBottomConstriant: Constraint?
    
    private let backgroundView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let buttonStackView = UIStackView(frame: .zero)
    private let cancelButton = UIButton(frame: .zero)
    private let button = UIButton(frame: .zero)
    
    private let viewModel: BottomModalViewModel
    
}
