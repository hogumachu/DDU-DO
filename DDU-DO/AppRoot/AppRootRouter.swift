//
//  AppRootRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol AppRootInteractable: Interactable, HomeListener, CalendarListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    private let homeBuildable: HomeBuildable
    private var homeRouting: Routing?
    
    private let calendarBuildable: CalendarBuildable
    private var calendarRouting: Routing?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        homeBuildable: HomeBuildable,
        calendarBuildable: CalendarBuildable
    ) {
        self.homeBuildable = homeBuildable
        self.calendarBuildable = calendarBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func setupTabs() {
        guard homeRouting == nil, calendarRouting == nil else { return }
        let homeRouter = homeBuildable.build(withListener: interactor)
        self.homeRouting = homeRouter
        attachChild(homeRouter)
        
        let calendarRouter = calendarBuildable.build(withListener: interactor)
        self.calendarRouting = calendarRouter
        attachChild(calendarRouter)
        
        viewController.setViewControllers([
            NavigationControllable(root: homeRouter.viewControllable),
            NavigationControllable(root: calendarRouter.viewControllable)
        ])
    }
    
}
