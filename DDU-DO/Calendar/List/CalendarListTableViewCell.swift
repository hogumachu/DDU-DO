//
//  CalendarListTableViewCell.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/24.
//

import UIKit
import SnapKit
import Then

protocol CalendarListTableViewCellDelegate: AnyObject {
    
    func calendarListTableViewCellDidSelectComplete(_ cell: CalendarListTableViewCell, didSelectAt indexPath: IndexPath)
    
}

struct CalendarListTableViewCellModel {
    
    let text: String?
    let isComplete: Bool
    
}

final class CalendarListTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    weak var delegate: CalendarListTableViewCellDelegate?
    
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
        self.contentLabel.attributedText = nil
        self.containerView.backgroundColor = .blue1
    }
    
    func configure(_ model: CalendarListTableViewCellModel) {
        if model.isComplete {
            self.contentLabel.attributedText = NSMutableAttributedString(string: model.text ?? "")
                .strikethrough()
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 15, weight: .heavy))
            self.containerView.backgroundColor = .blue4
            self.completeImageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        } else {
            self.contentLabel.attributedText = NSMutableAttributedString(string: model.text ?? "")
            self.containerView.backgroundColor = .blue1
            self.completeImageView.image = nil
        }
    }
    
    private func setupLayout() {
        self.contentView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        }
        
        self.containerView.addSubview(self.completeImageView)
        self.completeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.containerView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
            make.trailing.equalTo(self.completeImageView.snp.leading).offset(-10)
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .backgroundBlue
        self.selectionStyle = .none
        
        self.containerView.do {
            $0.backgroundColor = .blue1
            $0.layer.cornerRadius = 16
        }
        
        self.completeImageView.do {
            $0.backgroundColor = .lightBlue
            $0.layer.cornerRadius = 10
            $0.contentMode = .center
            $0.tintColor = .blue2
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(completeImageViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        self.contentLabel.do {
            $0.textColor = .lightBlue
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
        }
    }
    
    @objc private func completeImageViewDidTap(_ sender: UIGestureRecognizer) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.calendarListTableViewCellDidSelectComplete(self, didSelectAt: indexPath)
    }
    
    private let containerView = UIView(frame: .zero)
    private let completeImageView = UIImageView(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    
}
