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
        self.setupFeedbackGenerator()
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
            
        case let .showRecordView(useCase, targetDate):
            self.showRecordView(useCase: useCase, targetDate: targetDate)
            
        case let .showDetailView(useCase, entity):
            self.showDetailView(useCase: useCase, entity: entity)
            
        case let .showSettingView(useCase):
            self.showSettingView(useCase: useCase)
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
            $0.backgroundColor = .gray0
        }
        
        self.navigationView.do {
            $0.delegate = self
            $0.configure(.init(type: .info))
            $0.backgroundColor = .gray0
            $0.updateTintColor(.blueBlack)
        }
    }
    
    private func setupFeedbackGenerator() {
        self.selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        self.selectionFeedbackGenerator?.prepare()
        
        self.impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        self.impactFeedbackGenerator?.prepare()
        
        self.notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        self.notificationFeedbackGenerator?.prepare()
    }
    
    private func selectionChanged() {
        self.selectionFeedbackGenerator?.selectionChanged()
        self.selectionFeedbackGenerator?.prepare()
    }
    
    private func impactOccurred() {
        self.impactFeedbackGenerator?.impactOccurred()
        self.impactFeedbackGenerator?.prepare()
    }
    
    private func notifictaionOccured(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.notificationFeedbackGenerator?.notificationOccurred(type)
    }
    
    private func showRecordView(useCase: TodoUseCase, targetDate: Date) {
        let recordViewModel = RecordViewModel(todoUseCase: useCase, targetDate: targetDate)
        let recordViewController = RecordViewController(viewModel: recordViewModel)
        recordViewController.delegate = self
        recordViewController.presentWithAnimation(from: self)
    }
    
    private func showDetailView(useCase: TodoUseCase, entity: TodoEntity) {
        let detailViewModel = TodoDetailViewModel(todoUseCase: useCase, entity: entity)
        let detailViewController = TodoDetailViewController(viewModel: detailViewModel)
        detailViewController.presentWithAnimation(from: self)
        detailViewController.delegate = self
    }
    
    private func showSettingView(useCase: TodoUseCase) {
        let settingViewModel = SettingViewModel(todoUseCase: useCase)
        let settingViewController = SettingViewController(viewModel: settingViewModel).then {
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
    
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
        
        if offset > 20 {
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
        self.selectionChanged()
    }
    
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        self.viewModel.didSelectAllComplete(indexPath: indexPath)
        self.impactOccurred()
    }
    
}

extension HomeViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .success)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .error)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension HomeViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .success)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .success)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .error)
    }
    
}

extension HomeViewController: NavigationViewDelegate {
    
    func navigationViewDidTapLeftButton(_ view: NavigationView) {
        
    }
    
    func navigationViewDidTapRightButton(_ view: NavigationView) {
        self.viewModel.didTapNavigationRightButton()
    }
    
}

extension HomeViewController: TopScrollable {
    
    func scrollToTop() {
        self.homeView.scrollToTop()
    }
    
}
