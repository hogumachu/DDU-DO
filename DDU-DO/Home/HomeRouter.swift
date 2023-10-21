//
//  HomeRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs

protocol HomeInteractable: Interactable {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    override init(interactor: HomeInteractable, viewController: HomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSetting() {
        print("# Attach Setting")
    }
    
    func attachRecord(target: Date) {
        print("# Attach Record: \(target)")
    }
    
    func attachDetail(entity: TodoEntity) {
        print("# Attach Detail: \(entity)")
    }
    
}
