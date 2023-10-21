//
//  AppRootRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol AppRootInteractable: Interactable, HomeListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    private var homeBuildable: HomeBuildable
    private var homeRouting: Routing?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        homeBuildable: HomeBuildable
    ) {
        self.homeBuildable = homeBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func setupTabs() {
        guard homeRouting == nil else { return }
        let homeRouter = homeBuildable.build(withListener: interactor)
        self.homeRouting = homeRouter
        attachChild(homeRouter)
        viewController.setViewControllers([
            homeRouter.viewControllable
        ])
    }
    
}
