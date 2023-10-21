//
//  ViewControllable+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import UIKit

public extension ViewControllable {
    
    private var navigation: UINavigationController? {
        return uiviewController as? UINavigationController ?? uiviewController.navigationController
    }
    
    func present(_ viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)? = nil) {
        uiviewController.present(viewControllable.uiviewController, animated: animated, completion: completion)
    }
    
    func dismiss(animted: Bool, completion: (() -> Void)? = nil) {
        uiviewController.dismiss(animated: animted, completion: completion)
    }
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        navigation?.pushViewController(viewControllable.uiviewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        navigation?.popViewController(animated: animated)
    }
    
    func setViewControllers(_ viewControllables: [ViewControllable], animated: Bool) {
        navigation?.setViewControllers(viewControllables.map(\.uiviewController), animated: animated)
    }
    
}
