//
//  SettingBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol SettingDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
}

final class SettingComponent: Component<SettingDependency>, SettingInteractorDependency {
    var todoUsease: TodoUseCase { dependency.todoUseCase }

}

// MARK: - Builder

protocol SettingBuildable: Buildable {
    func build(withListener listener: SettingListener) -> SettingRouting
}

final class SettingBuilder: Builder<SettingDependency>, SettingBuildable {

    override init(dependency: SettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingListener) -> SettingRouting {
        let component = SettingComponent(dependency: dependency)
        let viewController = SettingViewController()
        let interactor = SettingInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SettingRouter(interactor: interactor, viewController: viewController)
    }
}
