//
//  AppRootViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift
import UIKit
import Then

protocol AppRootPresentableListener: AnyObject {}

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllable {

    weak var listener: AppRootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarFrame()
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    private func setupTabBar() {
        let apperance: UITabBarAppearance = tabBar.standardAppearance.then {
            $0.configureWithDefaultBackground()
            $0.backgroundColor = .gray0
            $0.shadowColor = nil
            $0.stackedItemPositioning = .automatic
            $0.stackedLayoutAppearance.normal.iconColor = .gray2
            $0.stackedLayoutAppearance.selected.iconColor = .green2
        }
        
        tabBar.do {
            $0.barStyle = .default
            $0.standardAppearance = apperance
            if #available(iOS 15.0, *) {
                $0.scrollEdgeAppearance = $0.standardAppearance
            }
            $0.isTranslucent = false
        }
    }
    
    private func setupTabBarFrame() {
        tabBar.frame.size = CGSize(
            width: tabBar.frame.width,
            height: 50 + view.safeAreaInsets.bottom
        )
        tabBar.frame.origin.y = view.frame.maxY - tabBar.frame.height
    }
    
}
