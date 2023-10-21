//
//  HomeViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

protocol HomePresentableListener: AnyObject {
    func didTapSetting()
    func didSelectAdd(at indexPath: IndexPath)
    func didSelectComplete(at indexPath: IndexPath, tag: Int)
    func didSelectAllComplete(indexPath: IndexPath)
    func didSelect(at indexPath: IndexPath, tag: Int)
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    weak var listener: HomePresentableListener?
    
    private var sections: [HomeSection] = []
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttributes()
    }
    
    func updateSections(_ sections: [HomeSection]) {
        self.sections = sections
        homeView.reloadData()
    }
    
    private func setupLayout() {
        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeArea.top)
        }
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        homeView.delegate = self
        homeView.dataSource = self
        statusView.do {
            $0.backgroundColor = .gray0
        }
        
        navigationView.do {
            $0.delegate = self
            $0.configure(.init(type: .info))
            $0.backgroundColor = .gray0
            $0.updateTintColor(.blueBlack)
        }
    }
    
}

extension HomeViewController: HomeViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.viewModel.didSelectRow(at: indexPath)
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sections[safe: indexPath.section]?.items[indexPath.row] else {
            return UITableViewCell()
        }
        
        switch item {
        case .title(let title):
            let cell = tableView.dequeueReusableCell(cell: TextOnlyTableViewCell.self, for: indexPath)
            let model = TextOnlyTableViewCellModel(text: title, font: .systemFont(ofSize: 22, weight: .bold))
            cell.configure(model, inset: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20))
            return cell
            
        case .todo(let model, _):
            let cell = tableView.dequeueReusableCell(cell: HomeTodoTableViewCell.self, for: indexPath)
            cell.configure(model)
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
    }
    
}

extension HomeViewController: HomeTodoTableViewCellDelegate {
    
    func homeTodoTableViewCellDidSelect(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int) {
        listener?.didSelect(at: indexPath, tag: tag)
    }
    
    
    func homeTodoTableViewCellDidSelectAdd(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        listener?.didSelectAdd(at: indexPath)
    }
    
    func homeTodoTableViewCellDidSelectComplete(_ cell: HomeTodoTableViewCell, indexPath: IndexPath, didSelectAt tag: Int) {
        listener?.didSelectComplete(at: indexPath, tag: tag)
    }
    
    func homeTodoTableViewCellDidSelectCompleteAllButton(_ cell: HomeTodoTableViewCell, indexPath: IndexPath) {
        listener?.didSelectAllComplete(indexPath: indexPath)
    }
    
}

extension HomeViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
//        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
//        ToastManager.showToast(toastModel)
//        self.notifictaionOccured(type: .success)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
//        let toastModel = ToastModel(message: message, type: .fail)
//        ToastManager.showToast(toastModel)
//        self.notifictaionOccured(type: .error)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension HomeViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
//        let toastModel = ToastModel(message: message, type: .success)
//        ToastManager.showToast(toastModel)
//        self.notifictaionOccured(type: .success)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
//        let toastModel = ToastModel(message: message, type: .fail)
//        ToastManager.showToast(toastModel)
//        self.notifictaionOccured(type: .error)
    }
    
}

extension HomeViewController: NavigationViewDelegate {
    
    func navigationViewDidTapLeftButton(_ view: NavigationView) {
        
    }
    
    func navigationViewDidTapRightButton(_ view: NavigationView) {
        listener?.didTapSetting()
    }
    
}

extension HomeViewController: TopScrollable {
    
    func scrollToTop() {
        homeView.scrollToTop()
    }
    
}
