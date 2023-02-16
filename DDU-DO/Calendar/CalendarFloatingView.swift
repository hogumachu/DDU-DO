//
//  CalendarFloatingView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/14.
//

import UIKit
import SnapKit
import Then

final class CalendarFloatingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBackgroundColor(_ color: UIColor?) {
        self.containerView.backgroundColor = color
        self.containerShadowView.backgroundColor = color
    }
    
    func updateTintColor(_ color: UIColor?){
        self.imageView.tintColor = color
        self.titleLabel.textColor = color
    }
    
    func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    func showTitle(_ text: String?) {
        self.titleLabel.isHidden = false
        self.titleLabel.text = text
    }
    
    func hideTitle() {
        self.titleLabel.isHidden = true
    }
    
    func updateRadius(_ cornerRadius: CGFloat) {
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerShadowView.layer.cornerRadius = cornerRadius
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.containerView.addSubview(self.contentStackView)
        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.contentStackView.addArrangedSubview(self.imageView)
        self.contentStackView.addArrangedSubview(self.titleLabel)
        
        self.insertSubview(self.containerShadowView, belowSubview: self.containerView)
        self.containerShadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }
    }
    
    private func setupAttributes() {
        self.imageView.do {
            $0.contentMode = .center
        }
        
        self.containerShadowView.do {
            $0.clipsToBounds = false
            $0.applyShadow(
                color: .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: 4),
                blur: 16
            )
        }
        
        self.contentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        self.titleLabel.do {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textAlignment = .center
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let containerShadowView = UIView(frame: .zero)
    private let contentStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    
}
