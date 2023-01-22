//
//  RootViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/22.
//

import UIKit
import SnapKit
import Then

final class RootViewController: UITabBarController {
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
        self.setupTabBarViewControllers()
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.frame.size = CGSize(width: self.tabBar.frame.width, height: 50 + self.view.safeAreaInsets.bottom)
        self.tabBar.frame.origin.y = self.view.frame.maxY - self.tabBar.frame.height
    }
    
    private func setupTabBar() {
        let apperance: UITabBarAppearance = self.tabBar.standardAppearance.then {
            $0.configureWithDefaultBackground()
            $0.backgroundColor = .white
            
            let font = UIFont.systemFont(ofSize: 11, weight: .regular)
            let selectedFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [.font: font]
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [.font: selectedFont]
            $0.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            $0.stackedItemPositioning = .centered
        }
        
        self.tabBar.do {
            $0.barStyle = .default
            $0.standardAppearance = apperance
            if #available(iOS 15.0, *) {
                $0.scrollEdgeAppearance = $0.standardAppearance
            }
            $0.isTranslucent = false
            $0.tintColor = .black
            $0.unselectedItemTintColor = .gray
        }
    }
    
    private func setupTabBarViewControllers() {
        let viewControllers: [UINavigationController] = [
            self.homeViewController,
            self.calendarViewController
        ]
        
        self.setViewControllers(viewControllers, animated: false)
        self.currentIndex = 0
        self.selectedIndex = 0
    }
    
    private lazy var homeViewController: UINavigationController = {
        let viewModel = HomeViewModel(todoRepository: self.todoRepository)
        let viewController = HomeViewController(viewModel: viewModel).then {
            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
            $0.tabBarItem.title = "홈"
        }
        
        return UINavigationController(rootViewController: viewController).then {
            $0.setNavigationBarHidden(true, animated: false)
            $0.interactivePopGestureRecognizer?.delegate = nil
        }
    }()
    
    private lazy var calendarViewController: UINavigationController = {
        let viewController = CalendarViewController().then {
            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), selectedImage: nil)
            $0.tabBarItem.title = "캘린더"
        }
        
        return UINavigationController(rootViewController: viewController).then {
            $0.setNavigationBarHidden(true, animated: false)
            $0.interactivePopGestureRecognizer?.delegate = nil
        }
    }()
    
    private let todoRepository: TodoRepository<TodoEntity>
    private var currentIndex: Int?
    
}

extension RootViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.currentIndex = tabBarController.selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }
        
        if self.currentIndex == index {
            viewController.scrollToTopIfEnabled()
        }
        
        return true
    }
    
}

extension RootViewController: Refreshable {
    
    func refresh() {
        guard let index = self.currentIndex, let viewController = self.viewControllers?[safe: index] else { return }
        
        viewController.refreshIfEnabled()
    }
    
}
