////
////  RootViewController.swift
////  DDU-DO
////
////  Created by 홍성준 on 2023/01/22.
////
//
//import UIKit
//import SnapKit
//import Then
//
//final class RootViewController: UITabBarController {
//
//    init(todoUseCase: TodoUseCase) {
//        self.todoUseCase = todoUseCase
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.setupTabBar()
//        self.setupTabBarViewControllers()
//        self.setupGradient()
//        self.delegate = self
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.tabBar.frame.size = CGSize(width: self.tabBar.frame.width, height: 50 + self.view.safeAreaInsets.bottom)
//        self.tabBar.frame.origin.y = self.view.frame.maxY - self.tabBar.frame.height
//        self.gradientLayer.frame = self.gradientView.bounds
//    }
//
//    private func setupTabBar() {
//        let apperance: UITabBarAppearance = self.tabBar.standardAppearance.then {
//            $0.configureWithDefaultBackground()
//            $0.backgroundColor = .gray0
//            $0.shadowColor = nil
//            $0.stackedItemPositioning = .automatic
//            $0.stackedLayoutAppearance.normal.iconColor = .gray2
//            $0.stackedLayoutAppearance.selected.iconColor = .green2
//        }
//
//        self.tabBar.do {
//            $0.barStyle = .default
//            $0.standardAppearance = apperance
//            if #available(iOS 15.0, *) {
//                $0.scrollEdgeAppearance = $0.standardAppearance
//            }
//            $0.isTranslucent = false
//        }
//    }
//
//    private func setupTabBarViewControllers() {
//        let viewControllers: [UINavigationController] = [
//            self.homeViewController,
//            self.calendarViewController
//        ]
//
//        self.setViewControllers(viewControllers, animated: false)
//        self.currentIndex = 0
//        self.selectedIndex = 0
//    }
//
//    private lazy var homeViewController: UINavigationController = {
//        let viewModel = HomeViewModel(todoUseCase: todoUseCase)
//        let viewController = HomeViewController(viewModel: viewModel).then {
//            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
//        }
//
//        return UINavigationController(rootViewController: viewController).then {
//            $0.setNavigationBarHidden(true, animated: false)
//            $0.interactivePopGestureRecognizer?.delegate = nil
//        }
//    }()
//
//    private func setupGradient() {
//        self.gradientView.do {
//            $0.isUserInteractionEnabled = false
//            $0.layer.insertSublayer(self.gradientLayer, at: 0)
//        }
//
//        self.view.addSubview(self.gradientView)
//        self.gradientView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(25)
//            make.bottom.equalTo(self.view.safeArea.bottom).offset(-50)
//        }
//    }
//
//    private lazy var calendarViewController: UINavigationController = {
//        let viewModel = CalendarViewModel(todoUseCase: todoUseCase)
//        let viewController = CalendarViewController(viewModel: viewModel).then {
//            $0.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), selectedImage: nil)
//        }
//
//        return UINavigationController(rootViewController: viewController).then {
//            $0.setNavigationBarHidden(true, animated: false)
//            $0.interactivePopGestureRecognizer?.delegate = nil
//        }
//    }()
//
//    private let todoUseCase: TodoUseCase
//    private var currentIndex: Int?
//    private let gradientView = UIView(frame: .zero)
//    private var gradientLayer: CAGradientLayer = {
//        CAGradientLayer().then {
//            $0.colors = [
//                UIColor.gray0?.withAlphaComponent(0).cgColor,
//                UIColor.gray0?.cgColor
//            ]
//            $0.locations = [0, 1]
//        }
//    }()
//
//}
//
//extension RootViewController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        self.currentIndex = tabBarController.selectedIndex
//    }
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }
//
//        if self.currentIndex == index {
//            viewController.scrollToTopIfEnabled()
//        }
//
//        return true
//    }
//
//}
//
//extension RootViewController: Refreshable {
//
//    func refresh() {
//        guard let index = self.currentIndex, let viewController = self.viewControllers?[safe: index] else { return }
//
//        viewController.refreshIfEnabled()
//    }
//
//}
