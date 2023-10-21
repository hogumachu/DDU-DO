//
//  AppRootInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift

protocol AppRootRouting: ViewableRouting {
    func setupTabs()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
}

protocol AppRootListener: AnyObject {}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {

    weak var router: AppRootRouting?
    weak var listener: AppRootListener?

    override init(presenter: AppRootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.setupTabs()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
