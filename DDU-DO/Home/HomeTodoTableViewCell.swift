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
    
    func homeTodoTableViewCellDidSelectAdd(_ cell: HomeTodoTableViewCell, indexPath: IndexPath)
    func homeTodoTableViewCellDidSelectComplete(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int)
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell)
    
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
        self.updateType(model.type)
        
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
    
    private func updateType(_ type: HomeTodoType) {
        switch type {
        case .today:
            self.containerView.backgroundColor = .purple1
            self.titleLabel.textColor = .lightPurple
            self.subtitleLabel.textColor = .lightPurple
            self.addImageView.tintColor = .purple1
            self.addImageView.backgroundColor = .lightPurple
            self.allCompleteButton.isHidden = false
            self.itemStackViewBottomConstraint?.update(offset: -90)
            
        case .etc:
            self.containerView.backgroundColor = .lightPurple
            self.titleLabel.textColor = .purple1
            self.subtitleLabel.textColor = .purple1
            self.addImageView.tintColor = .lightPurple
            self.addImageView.backgroundColor = .purple1
            self.allCompleteButton.isHidden = true
            self.itemStackViewBottomConstraint?.update(offset: -20)
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
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
            self.itemStackViewBottomConstraint = make.bottom.equalToSuperview().offset(-90).constraint
        }
        
        self.containerView.addSubview(self.allCompleteButton)
        self.allCompleteButton.snp.makeConstraints { make in
            make.top.equalTo(self.itemStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupAttributes() {
        self.selectionStyle = .none
        self.backgroundColor = .darkPurple
        
        self.containerView.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .purple1
        }
        
        self.titleLabel.do {
            $0.textColor = .lightPurple
            $0.font = .systemFont(ofSize: 22, weight: .bold)
        }
        
        self.subtitleLabel.do {
            $0.textColor = .lightPurple
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        self.addImageView.do {
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
            $0.image = UIImage(systemName: "plus", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .center
            $0.tintColor = .purple1
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .lightPurple
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
            $0.backgroundColor = .lightPurple
            $0.layer.cornerRadius = 16
            $0.setTitle("모두 완료하기", for: .normal)
            $0.setTitleColor(.purple2, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        }
    }
    
    @objc private func addImageViewDidTap(_ sender: UIGestureRecognizer) {
        guard let indexPath = indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelectAdd(self, indexPath: indexPath)
    }
    
    private var itemStackViewBottomConstraint: Constraint?
    
    private let containerView = UIView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let addImageView = UIImageView(frame: .zero)
    private let itemStackView = UIStackView(frame: .zero)
    private let allCompleteButton = UIButton(frame: .zero)
    
}

extension HomeTodoTableViewCell: HomeTodoItemViewDelegate {
    
    func homeTodoItemViewDidSelectComplete(_ view: HomeTodoItemView, tag: Int) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.homeTodoTableViewCellDidSelectComplete(self, indexPath: indexPath, didSelectAt: tag)
    }
    
}
