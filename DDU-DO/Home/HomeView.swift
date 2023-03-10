//
//  HomeView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then

typealias HomeViewDelegate = UITableViewDelegate
typealias HomeViewDataSource = UITableViewDataSource

final class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate? {
        didSet { self.tableView.delegate = self.delegate }
    }
    
    weak var dataSource: HomeViewDataSource? {
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
    
    func reloadData() {
        self.tableView.reloadData()
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
    }
    
    private func setupAttributes() {
        self.tableView.do {
            $0.backgroundColor = .gray0
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.registerCell(cell: TextOnlyTableViewCell.self)
            $0.registerCell(cell: HomeTodoTableViewCell.self)
            $0.sectionHeaderHeight = 20
            $0.sectionFooterHeight = .leastNonzeroMagnitude
            $0.tableHeaderView = UIView().then({
                $0.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
            })
            $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
}
