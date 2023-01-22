//
//  UIViewController+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit

extension UIViewController {
    
    func scrollToTopIfEnabled() {
        if let navigationController = self as? UINavigationController {
            (navigationController.topViewController as? TopScrollable)?.scrollToTop()
        } else {
            (self as? TopScrollable)?.scrollToTop()
        }
    }
    
    func refreshIfEnabled() {
        if let navigationController = self as? UINavigationController {
            (navigationController.topViewController as? Refreshable)?.refresh()
        } else {
            (self as? Refreshable)?.refresh()
        }
    }
    
}
