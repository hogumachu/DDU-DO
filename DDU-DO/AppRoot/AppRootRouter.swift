//
//  AppRootRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol AppRootInteractable: Interactable {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    override init(interactor: AppRootInteractable, viewController: AppRootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func setupTabs() {
        
    }
    
}
