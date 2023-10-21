//
//  AppRootViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift
import UIKit

protocol AppRootPresentableListener: AnyObject {}

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllable {

    weak var listener: AppRootPresentableListener?
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
}
