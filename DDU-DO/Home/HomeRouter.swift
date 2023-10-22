//
//  HomeRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs

protocol HomeInteractable: Interactable, SettingListener, RecordListener, TodoDetailListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let settingBuildable: SettingBuildable
    private var settingRouting: Routing?
    
    private let recordBuildable: RecordBuildable
    private var recordRouting: Routing?
    
    private let todoDetailBuildable: TodoDetailBuildable
    private var todoDetailRouting: Routing?
    
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        settingBuildable: SettingBuildable,
        recordBuildable: RecordBuildable,
        todoDetailBuildable: TodoDetailBuildable
    ) {
        self.settingBuildable = settingBuildable
        self.recordBuildable = recordBuildable
        self.todoDetailBuildable = todoDetailBuildable
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
        guard recordRouting == nil else { return }
        let recordRouter = recordBuildable.build(withListener: interactor, targetDate: target)
        self.recordRouting = recordRouter
        attachChild(recordRouter)
        viewController.pushViewController(recordRouter.viewControllable, animated: true)
    }
    
    func detachRecord() {
        guard let recordRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(recordRouting)
        self.recordRouting = nil
    }
    
    func attachDetail(entity: TodoEntity) {
        guard todoDetailRouting == nil else { return }
        let detailRouter = todoDetailBuildable.build(withListener: interactor, entity: entity)
        self.todoDetailRouting = detailRouter
        attachChild(detailRouter)
        viewController.pushViewController(detailRouter.viewControllable, animated: true)
    }
    
    func detachDetail() {
        guard let todoDetailRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(todoDetailRouting)
        self.todoDetailRouting = nil
    }
    
}
