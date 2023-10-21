//
//  SettingView.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/15.
//

import UIKit
import SnapKit
import Then

typealias SettingViewDelegate = UITableViewDelegate & NavigationViewDelegate
typealias SettingViewDataSource = UITableViewDataSource

final class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate? {
        didSet {
            self.navigationView.delegate = self.delegate
            self.tableView.delegate = self.delegate
        }
    }
    
    weak var dataSource: SettingViewDataSource? {
        didSet {
            self.tableView.dataSource = self.dataSource
        }
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
        
    }
    
    private func setupLayout() {
        self.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.backgroundColor = .gray0
        
        self.navigationView.do {
            $0.backgroundColor = .gray0
            $0.configure(.init(type: .back))
            $0.updateTitle("설정")
            $0.updateTintColor(.blueBlack)
        }
        
        self.tableView.do {
            $0.registerCell(cell: SettingTableViewCell.self)
            $0.backgroundColor = .gray0
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderHeight = .leastNonzeroMagnitude
            $0.sectionFooterHeight = .leastNonzeroMagnitude
            $0.tableHeaderView = UIView().then({
                $0.frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
            })
        }
    }
    
    private let navigationView = NavigationView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
}
