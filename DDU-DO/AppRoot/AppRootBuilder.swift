//
//  AppRootBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol AppRootDependency: Dependency {}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = AppRootComponent(dependency: dependency)
        let viewController = AppRootViewController()
        let interactor = AppRootInteractor(presenter: viewController)
        return AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuildable: HomeBuilder(dependency: component),
            calendarBuildable: CalendarBuilder(dependency: component)
        )
    }
    
}
