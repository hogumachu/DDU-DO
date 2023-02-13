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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationView.updateBlurFrame()
        self.navigationView.snp.updateConstraints { make in
            make.height.equalTo(40 + UIScreen.topSafeAreaInset)
        }
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
    
    private func setupHomeView() {
        self.view.addSubview(self.homeView)
        self.homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        self.homeView.delegate = self
        self.homeView.dataSource = self
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
    
    private let navigationView = HomeNavigationView(frame: .zero)
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
    
    func homeTodoTableViewCellDidSelectAdd(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        self.viewModel.didSelectAdd(at: indexPath)
    }
    
    func homeTodoTableViewCellDidSelectComplete(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int) {
        self.viewModel.didSelectComplete(indexPath: indexPath, at: tag)
    }
    
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell) {
        // TODO: - Complete 상황에 따라 Active InActive 설정하기
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

