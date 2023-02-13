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
        self.setupLayout()
        self.setupAttributes()
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
            
        case let .showRecordView(repository, targetDate):
            self.showRecordView(repository: repository, targetDate: targetDate)
            
        case let .showDetailView(repository, entity):
            self.showDetailView(repository: repository, entity: entity)
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.statusView)
        self.statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.top)
        }
        
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.view.addSubview(self.homeView)
        self.homeView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.homeView.delegate = self
        self.homeView.dataSource = self
        self.statusView.do {
            $0.backgroundColor = .darkPurple
        }
        
        self.navigationView.do {
            $0.configure(.init(type: .logo(style: .darkContent)))
            $0.backgroundColor = .darkPurple
        }
    }
    
    private func showRecordView(repository: TodoRepository<TodoEntity>, targetDate: Date) {
        let recordViewModel = RecordViewModel(todoRepository: repository, targetDate: targetDate)
        let recordViewController = RecordViewController(viewModel: recordViewModel)
        recordViewController.delegate = self
        recordViewController.presentWithAnimation(from: self)
    }
    
    private func showDetailView(repository: TodoRepository<TodoEntity>, entity: TodoEntity) {
        let detailViewModel = TodoDetailViewModel(repository: repository, entity: entity)
        let detailViewController = TodoDetailViewController(viewModel: detailViewModel)
        detailViewController.presentWithAnimation(from: self)
        detailViewController.delegate = self
    }
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let homeView = HomeView(frame: .zero)
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
}

extension HomeViewController: HomeViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset > 0 {
            self.navigationView.showSeparator()
        } else {
            self.navigationView.hideSeparator()
        }
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
            
        case .todo(let model, _):
            guard let cell = tableView.dequeueReusableCell(cell: HomeTodoTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            cell.configure(model)
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
    }
    
}

extension HomeViewController: HomeTodoTableViewCellDelegate {
    
    func homeTodoTableViewCellDidSelect(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int) {
        self.viewModel.didSelectRow(indexPath: indexPath, at: tag)
    }
    
    
    func homeTodoTableViewCellDidSelectAdd(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        self.viewModel.didSelectAdd(at: indexPath)
    }
    
    func homeTodoTableViewCellDidSelectComplete(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int) {
        self.viewModel.didSelectComplete(indexPath: indexPath, at: tag)
    }
    
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        self.viewModel.didSelectAllComplete(indexPath: indexPath)
    }
    
}

extension HomeViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
        ToastManager.showToast(toastModel)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension HomeViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .success)
        ToastManager.showToast(toastModel)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
    }
    
}

