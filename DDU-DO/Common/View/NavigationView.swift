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
    case logo(style: NavigationLogoStyle)
    case logoWithInfo(style: NavigationLogoStyle)
    case info
    case none
    
}

enum NavigationLogoStyle {
    
    case lightContent
    case darkContent
    
    var named: String {
        switch self {
        case .lightContent:                       return "logo_light_content"
        case .darkContent:                  return "logo_dark_content"
        }
    }
    
}

extension NavigationViewType {
    
    var leftImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return UIImage(systemName: "arrow.backward", withConfiguration: config)
        case .logo:                         return nil
        case .logoWithInfo:                 return nil
        case .info:                         return nil
        case .none:                         return nil
        }
    }
    
    var rightImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return nil
        case .logo:                         return nil
        case .logoWithInfo:                 return UIImage.init(systemName: "line.3.horizontal", withConfiguration: config)
        case .info:                         return UIImage.init(systemName: "line.3.horizontal", withConfiguration: config)
        case .none:                         return nil
        }
    }
    
    var logoImage: UIImage? {
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
        
        switch self {
        case .back:                         return nil
        case .logo(let style):              return UIImage(named: style.named, in: Bundle.main, with: config)
        case .logoWithInfo(let style):      return UIImage(named: style.named, in: Bundle.main, with: config)
        case .info:                         return nil
        case .none:                         return nil
        }
    }
    
}

struct NavigationViewModel {
    
    let type: NavigationViewType
    
}

final class NavigationView: UIView {
    
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
        self.logoImageView.image = model.type.logoImage
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
        self.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
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
    }
    
    private func setupAttributes() {
        self.logoImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        self.titleLabel.do {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        self.leftButton.do {
            $0.contentMode = .center
        }
        
        self.rightButton.do {
            $0.contentMode = .center
        }
        
        self.separator.do {
            $0.backgroundColor = .blue1
            $0.alpha = 0.0
        }
    }
    
    private let titleLabel = UILabel(frame: .zero)
    private let logoImageView = UIImageView(frame: .zero)
    private let leftButton = UIButton(frame: .zero)
    private let rightButton = UIButton(frame: .zero)
    private let separator = UIView(frame: .zero)
    
}
