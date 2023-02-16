//
//  NavigationView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/13.
//

import UIKit
import SnapKit
import Then

enum NavigationViewType {
    
    case back
    case info
    case none
    
}

extension NavigationViewType {
    
    var leftImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return UIImage(systemName: "arrow.backward", withConfiguration: config)
        case .info:                         return nil
        case .none:                         return nil
        }
    }
    
    var rightImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return nil
        case .info:                         return UIImage.init(systemName: "line.3.horizontal", withConfiguration: config)
        case .none:                         return nil
        }
    }
    
    var logoImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return nil
        case .info:                         return nil
        case .none:                         return nil
        }
    }
    
}

struct NavigationViewModel {
    
    let type: NavigationViewType
    
}

protocol NavigationViewDelegate: AnyObject {
    
    func navigationViewDidTapLeftButton(_ view: NavigationView)
    func navigationViewDidTapRightButton(_ view: NavigationView)
    
}

final class NavigationView: UIView {
    
    weak var delegate: NavigationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: NavigationViewModel) {
        self.leftButton.setImage(model.type.leftImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.rightButton.setImage(model.type.rightImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func updateTintColor(_ color: UIColor?) {
        self.leftButton.tintColor = color
        self.rightButton.tintColor = color
        self.titleLabel.textColor = color
    }
    
    func updateTitle(_ text: String?) {
        self.titleLabel.text = text
    }
    
    func showSeparator() {
        guard self.separator.alpha == 0.0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 1.0
        }
    }
    
    func hideSeparator() {
        guard self.separator.alpha == 1.0 else { return }
        UIView.animate(withDuration: 0.1) {
            self.separator.alpha = 0.0
        }
    }
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        self.addSubview(self.separator)
        self.separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.addSubview(self.leftButton)
        self.leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        self.addSubview(self.rightButton)
        self.rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        self.titleLabel.do {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        self.leftButton.do {
            $0.contentMode = .center
            $0.addTarget(self, action: #selector(leftButtonDidTap(_:)), for: .touchUpInside)
        }
        
        self.rightButton.do {
            $0.contentMode = .center
            $0.addTarget(self, action: #selector(rightButtonDidTap(_:)), for: .touchUpInside)
        }
        
        self.separator.do {
            $0.backgroundColor = .gray0
            $0.alpha = 0.0
        }
    }
    
    @objc private func leftButtonDidTap(_ sender: UIButton) {
        self.delegate?.navigationViewDidTapLeftButton(self)
    }
    
    @objc private func rightButtonDidTap(_ sender: UIButton) {
        self.delegate?.navigationViewDidTapRightButton(self)
    }
    
    private let titleLabel = UILabel(frame: .zero)
    private let leftButton = UIButton(frame: .zero)
    private let rightButton = UIButton(frame: .zero)
    private let separator = UIView(frame: .zero)
    
}
