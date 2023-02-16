//
//  HomeTodoTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/13.
//

import UIKit
import SnapKit
import Then

protocol HomeTodoTableViewCellDelegate: AnyObject {
    
    func homeTodoTableViewCellDidSelect(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int)
    func homeTodoTableViewCellDidSelectAdd(_ cell: HomeTodoTableViewCell, indexPath: IndexPath)
    func homeTodoTableViewCellDidSelectComplete(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int)
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell, indexPath: IndexPath)
    
}

enum HomeTodoType {
    
    case today
    case etc
    
}

struct HomeTodoTableViewCellModel {
    
    let title: String
    let subtitle: String
    let items: [HomeTodoItemViewModel]
    let type: HomeTodoType
    
}

final class HomeTodoTableViewCell: UITableViewCell {
    
    weak var delegate: HomeTodoTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.indexPath = nil
        self.itemStackView
            .subviews
            .forEach { $0.removeFromSuperview() }
    }
    
    func configure(_ model: HomeTodoTableViewCellModel) {
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.subtitle
        self.updateUI(model)
        
        self.itemStackView
            .subviews
            .forEach { $0.removeFromSuperview() }
       
        (0..<model.items.count)
            .map { _ in HomeTodoItemView(frame: .zero) }
            .enumerated()
            .forEach {
                $0.element.tag = $0.offset
                $0.element.configure(model.items[$0.offset], type: model.type)
                $0.element.delegate = self
                self.itemStackView.addArrangedSubview($0.element)
            }
    }
    
    private func updateUI(_ model: HomeTodoTableViewCellModel) {
        switch model.type {
        case .today:
            self.containerView.backgroundColor = .white
            self.titleLabel.textColor = .blueBlack
            self.subtitleLabel.textColor = .blueBlack
            self.addImageView.tintColor = .white
            self.addImageView.backgroundColor = .green2
            let isAllCompleteButtonEnabled = model.items.filter { $0.isComplete == false }.count != 0
            if isAllCompleteButtonEnabled {
                self.allCompleteButton.isHidden = false
                self.itemStackViewBottomConstraint?.update(offset: -80)
            } else {
                self.allCompleteButton.isHidden = true
                self.itemStackViewBottomConstraint?.update(offset: -20)
            }
            
        case .etc:
            self.containerView.backgroundColor = .green2
            self.titleLabel.textColor = .white
            self.subtitleLabel.textColor = .white
            self.addImageView.tintColor = .green2
            self.addImageView.backgroundColor = .white
            self.allCompleteButton.isHidden = true
            self.itemStackViewBottomConstraint?.update(offset: -20)
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        self.contentView.insertSubview(self.containerShadowView, belowSubview: self.containerView)
        self.containerShadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }
        
        self.containerView.addSubview(self.addImageView)
        self.addImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.top.trailing.equalToSuperview().inset(20)
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(self.addImageView.snp.leading).offset(-10)
        }
        
        self.containerView.addSubview(self.subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(self.addImageView.snp.leading).offset(-10)
        }
        
        self.containerView.addSubview(self.itemStackView)
        self.itemStackView.snp.makeConstraints { make in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            self.itemStackViewBottomConstraint = make.bottom.equalToSuperview().offset(-80).constraint
        }
        
        self.containerView.addSubview(self.allCompleteButton)
        self.allCompleteButton.snp.makeConstraints { make in
            make.top.equalTo(self.itemStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .gray0
        
        self.containerView.do {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
        }
        
        self.containerShadowView.do {
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = false
            $0.backgroundColor = .white
            $0.applyShadow(
                color: .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: -4),
                blur: 16
            )
        }
        
        self.titleLabel.do {
            $0.textColor = .blueBlack
            $0.font = .systemFont(ofSize: 22, weight: .bold)
        }
        
        self.subtitleLabel.do {
            $0.textColor = .blueBlack
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        self.addImageView.do {
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
            $0.image = UIImage(systemName: "plus", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .center
            $0.tintColor = .white
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .green2
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.itemStackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .fill
        }
        
        self.allCompleteButton.do {
            $0.backgroundColor = .green2
            $0.layer.cornerRadius = 16
            $0.setTitle("모두 완료하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(allCompleteButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func addImageViewDidTap(_ sender: UIGestureRecognizer) {
        guard let indexPath = indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelectAdd(self, indexPath: indexPath)
    }
    
    @objc private func allCompleteButtonDidTap(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelectCompleteAllButton(self, indexPath: indexPath)
    }
    
    private var itemStackViewBottomConstraint: Constraint?
    
    private let containerShadowView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let addImageView = UIImageView(frame: .zero)
    private let itemStackView = UIStackView(frame: .zero)
    private let allCompleteButton = UIButton(frame: .zero)
    
}

extension HomeTodoTableViewCell: HomeTodoItemViewDelegate {
    
    func homeTodoItemViewDidSelect(_ view: HomeTodoItemView, tag: Int) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelect(self, indexPath: indexPath, didSelectAt: tag)
    }
    
    func homeTodoItemViewDidSelectComplete(_ view: HomeTodoItemView, tag: Int) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelectComplete(self, indexPath: indexPath, didSelectAt: tag)
    }
    
}
