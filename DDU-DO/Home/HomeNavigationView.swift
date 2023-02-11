//
//  HomeNavigationView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

final class HomeNavigationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBlurFrame() {
        self.blurView.frame = self.frame
    }
    
    private func setupLayout() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.blurView)
        self.blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .clear
        self.titleLabel.do {
            $0.text = "DDU-DO"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 22, weight: .heavy)
        }
    }
    
    private let containerView = UIView(frame: .zero)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let titleLabel = UILabel(frame: .zero) // TODO: - Logo Image 로 변경하기
    
}
