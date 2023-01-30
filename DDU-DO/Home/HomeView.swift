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
    
    private func setupLayout() {
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.tableView.do {
            $0.registerCell(cell: TextOnlyTableViewCell.self)
            $0.registerCell(cell: HomeScheduleTableViewCell.self)
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
}