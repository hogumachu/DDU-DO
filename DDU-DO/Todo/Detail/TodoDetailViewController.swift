//
//  TodoDetailViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/30.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class TodoDetailViewController: UIViewController {
    
    init(viewModel: TodoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupDetailView()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel: TodoDetailViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: TodoDetailViewModelEvent) {
        switch event {
            // TODO: - DO SOMETHING
        }
    }
    
    private func setupDetailView() {
        self.view.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.detailView.do {
            $0.delegate = self
        }
    }
    
    private let detailView = TodoDetailView(frame: .zero)
    private let viewModel: TodoDetailViewModel
    private let disposeBag = DisposeBag()
    
}

extension TodoDetailViewController: TodoDetailViewDelegate {
    
    var todo: String? {
        self.viewModel.todo
    }
    
    func todoDetailViewDidTapSaveButton(_ view: TodoDetailView) {
        // DO Something
    }
    
    func todoDetailViewDidTapCancelButton(_ view: TodoDetailView) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
