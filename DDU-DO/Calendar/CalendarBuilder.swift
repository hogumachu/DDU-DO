//
//  CalendarBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol CalendarDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var calculator: CalendarCalculator { get }
}

final class CalendarComponent: Component<CalendarDependency>, CalendarInteractorDependency {
    var todoUseCase: TodoUseCase { dependency.todoUseCase }
    var calculator: CalendarCalculator { dependency.calculator }
}

// MARK: - Builder

protocol CalendarBuildable: Buildable {
    func build(withListener listener: CalendarListener) -> ViewableRouting
}

final class CalendarBuilder: Builder<CalendarDependency>, CalendarBuildable {

    override init(dependency: CalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CalendarListener) -> ViewableRouting {
        let component = CalendarComponent(dependency: dependency)
        let viewController = CalendarViewController()
        let interactor = CalendarInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return CalendarRouter(interactor: interactor, viewController: viewController)
    }
}
