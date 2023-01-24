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
            $0.registerCell(cell: CalendarListTableViewCell.self)
        }
    }
    
    private let tableView = UITableView(frame: .zero)
    
}
