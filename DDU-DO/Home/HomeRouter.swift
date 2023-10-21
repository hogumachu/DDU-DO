//
//  HomeRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs

protocol HomeInteractable: Interactable, SettingListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let settingBuildable: SettingBuildable
    private var settingRouting: Routing?
    
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        settingBuildable: SettingBuildable
    ) {
        self.settingBuildable = settingBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSetting() {
        guard settingRouting == nil else { return }
        let settingRouter = settingBuildable.build(withListener: interactor)
        self.settingRouting = settingRouter
        attachChild(settingRouter)
        viewController.pushViewController(settingRouter.viewControllable, animated: true)
    }
    
    func detachSetting() {
        guard let settingRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(settingRouting)
        self.settingRouting = nil
    }
    
    func attachRecord(target: Date) {
        print("# Attach Record: \(target)")
    }
    
    func attachDetail(entity: TodoEntity) {
        print("# Attach Detail: \(entity)")
    }
    
}
