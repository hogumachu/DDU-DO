//
//  HomeBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol HomeDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var calculator: CalendarCalculator { get }
    var settingBuildable: SettingBuildable { get }
    var recordBuildable: RecordBuildable { get }
}

final class HomeComponent: Component<HomeDependency>, HomeInteractorDependency {
    var todoUseCase: TodoUseCase { dependency.todoUseCase }
    var calculator: CalendarCalculator { dependency.calculator }
    var settingBuildable: SettingBuildable { dependency.settingBuildable }
    var recordBuildable: RecordBuildable { dependency.recordBuildable }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        let interactor = HomeInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return HomeRouter(
            interactor: interactor,
            viewController: viewController,
            settingBuildable: component.settingBuildable,
            recordBuildable: component.recordBuildable
        )
    }
}
