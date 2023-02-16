//
//  CalendarListView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/24.
//

import UIKit
import SnapKit
import Then

typealias CalendarListViewDelegate = UITableViewDelegate
typealias CalendarListViewDataSource = UITableViewDataSource

final class CalendarListView: UIView {
    
    weak var delegate: CalendarListViewDelegate? {
        didSet { self.tableView.delegate = self.delegate }
    }
    
    weak var dataSource: CalendarListViewDataSource? {
        didSet { self.tableView.dataSource = self.dataSource }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.gradientView.bounds
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showEmptyView() {
        self.emptyView.isHidden = false
    }
    
    func hideEmptyView() {
        self.emptyView.isHidden = true
    }
    
    func scrollToTop() {
        let inset = self.tableView.contentInset
        self.tableView.setContentOffset(
            CGPoint(x: -inset.left, y: -inset.top),
            animated: true
        )
    }
    
    private func setupLayout() {
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.gradientView)
        self.gradientView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.tableView)
        }
    }
    
    private func setupAttributes() {
        self.tableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.registerCell(cell: CalendarListTableViewCell.self)
            $0.contentInset = UIEdgeInsets(top: 55, left: 0, bottom: 100, right: 0)
            $0.showsVerticalScrollIndicator = false
        }
        
        self.emptyView.do {
            $0.isHidden = true
        }
        
        self.gradientView.do {
            $0.isUserInteractionEnabled = false
            $0.layer.insertSublayer(self.gradientLayer, at: 0)
        }
    }
    
    private let tableView = UITableView(frame: .zero)
    private let emptyView = CalendarListEmptyView(frame: .zero)
    private let gradientView = UIView(frame: .zero)
    private var gradientLayer: CAGradientLayer = {
        CAGradientLayer().then {
            $0.colors = [
                UIColor.white.cgColor,
                UIColor.white.withAlphaComponent(0).cgColor
            ]
            $0.locations = [0, 1]
        }
    }()
    
}
