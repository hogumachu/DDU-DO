//
//  NavigationControllable.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import UIKit

public final class NavigationControllable: ViewControllable {
    
    public var uiviewController: UIViewController { self.navigationController }
    public let navigationController: UINavigationController
    
    public init(root: ViewControllable) {
        let navigation = UINavigationController(rootViewController: root.uiviewController)
        navigation.navigationBar.isHidden = true
        self.navigationController = navigation
    }
}
