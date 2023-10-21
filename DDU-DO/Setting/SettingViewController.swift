//
//  SettingViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift
import UIKit

protocol SettingPresentableListener: AnyObject {
    func didTapClose()
    func didSelect(at indexPath: IndexPath)
}

final class SettingViewController: UIViewController, SettingPresentable, SettingViewControllable {

    weak var listener: SettingPresentableListener?
    
    private let settingView = SettingView(frame: .zero)
    
    private var sections: [SettingSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttributes()
    }
    
    func updateSections(_ sections: [SettingSection]) {
        self.sections = sections
        settingView.reloadData()
    }
    
    private func setupLayout() {
        view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        settingView.delegate = self
        settingView.dataSource = self
    }
    
    private func showModalView(_ viewModel: BottomModalViewModel) {
        let modalViewController = BottomModalViewController(viewModel: viewModel)
        modalViewController.presentWithAnimation(from: self)
//        modalViewController.delegate = self
    }
    
    private func showToast(_ message: String?, isSuccess: Bool) {
        guard let message = message else { return }
        let model = ToastModel(message: message, type: isSuccess ? .success : .fail)
        ToastManager.showToast(model)
    }
    
}

extension SettingViewController: SettingViewDelegate {
    
    func navigationViewDidTapLeftButton(_ view: NavigationView) {
        listener?.didTapClose()
    }
    
    func navigationViewDidTapRightButton(_ view: NavigationView) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didSelect(at: indexPath)
    }
    
}

extension SettingViewController: SettingViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
            return UITableViewCell()
        }
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
//        self.viewModel.bottomModalViewButtonDidTap()
    }
    
}
