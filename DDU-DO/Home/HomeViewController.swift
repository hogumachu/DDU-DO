//
//  HomeViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class HomeViewController: UIViewController {
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupHomeView()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: HomeViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: HomeViewModelEvent) {
        switch event {
        case .reloadData:
            self.homeView.reloadData()
        }
    }
    
    private func setupHomeView() {
        self.view.addSubview(self.homeView)
        self.homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.homeView.delegate = self
        self.homeView.dataSource = self
    }
    
    private let homeView = HomeView(frame: .zero)
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
}

extension HomeViewController: HomeViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(at: indexPath)
    }
    
}

extension HomeViewController: HomeViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.cellItem(at: indexPath) else { return UITableViewCell() }
        
        switch item {
        case .title(let title):
            guard let cell = tableView.dequeueReusableCell(cell: TextOnlyTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            let model = TextOnlyTableViewCellModel(text: title, font: .systemFont(ofSize: 22, weight: .bold))
            cell.configure(model, inset: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
            return cell
            
        case .schedule(let model):
            guard let cell = tableView.dequeueReusableCell(cell: HomeScheduleTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            cell.configure(model)
            return cell
        }
    }
    
}
