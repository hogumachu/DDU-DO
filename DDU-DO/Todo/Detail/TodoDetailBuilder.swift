//
//  TodoDetailBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs

protocol TodoDetailDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
}

final class TodoDetailComponent: Component<TodoDetailDependency>, TodoDetailInteractorDependency {
    var todoUseCase: TodoUseCase { dependency.todoUseCase }
    let entity: TodoEntity
    
    init(dependency: TodoDetailDependency, entity: TodoEntity) {
        self.entity = entity
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TodoDetailBuildable: Buildable {
    func build(withListener listener: TodoDetailListener, entity: TodoEntity) -> TodoDetailRouting
}

final class TodoDetailBuilder: Builder<TodoDetailDependency>, TodoDetailBuildable {

    override init(dependency: TodoDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TodoDetailListener, entity: TodoEntity) -> TodoDetailRouting {
        let component = TodoDetailComponent(dependency: dependency, entity: entity)
        let viewController = TodoDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        let interactor = TodoDetailInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return TodoDetailRouter(interactor: interactor, viewController: viewController)
    }
}
