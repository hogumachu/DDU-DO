//
//  SettingViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/15.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SettingViewController: UIViewController {
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupSettingView()
        self.bind(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(viewModel: SettingViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
        
    }
    
    private func handle(_ event: SettingViewModelEvent) {
        switch event {
        case .reloadData:
            self.settingView.reloadData()
            
        case .showModalView(let viewModel):
            self.showModalView(viewModel)
            
        case .didFinish(let message):
            self.showToast(message, isSuccess: true)
            self.navigationController?.popViewController(animated: true)
            
        case .didFail(let message):
            self.showToast(message, isSuccess: false)
        }
    }
    
    private func setupSettingView() {
        self.view.addSubview(self.settingView)
        self.settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.settingView.delegate = self
        self.settingView.dataSource = self
    }
    
    private func showModalView(_ viewModel: BottomModalViewModel) {
        let modalViewController = BottomModalViewController(viewModel: viewModel)
        modalViewController.presentWithAnimation(from: self)
        modalViewController.delegate = self
    }
    
    private func showToast(_ message: String?, isSuccess: Bool) {
        guard let message = message else { return }
        let model = ToastModel(message: message, type: isSuccess ? .success : .fail)
        ToastManager.showToast(model)
    }
    
    private let settingView = SettingView(frame: .zero)
    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()
    
}

extension SettingViewController: SettingViewDelegate {
    
    func navigationViewDidTapLeftButton(_ view: NavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationViewDidTapRightButton(_ view: NavigationView) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(at: indexPath)
    }
    
}

extension SettingViewController: SettingViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.cellItem(at: indexPath) else { return UITableViewCell() }
        switch item {
        case .title(let model):
            let cell = tableView.dequeueReusableCell(cell: SettingTableViewCell.self, for: indexPath)
            cell.configure(model)
            return cell
            
        case .detail(let model):
            let cell = tableView.dequeueReusableCell(cell: SettingTableViewCell.self, for: indexPath)
            cell.configure(model)
            return cell
        }
    }
    
}

extension SettingViewController: BottomModalViewControllerDelegate {
    
    func bottomModalViewControllerDidTapButton(_ viewController: BottomModalViewController) {
        self.viewModel.bottomModalViewButtonDidTap()
    }
    
}
