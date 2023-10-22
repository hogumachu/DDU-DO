//
//  RecordBuilder.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import Foundation
import RIBs

protocol RecordDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
}

final class RecordComponent: Component<RecordDependency>, RecordInteractorDependency {
    var todoUseCase: TodoUseCase { dependency.todoUseCase }
    let targetDate: Date
    
    init(dependency: RecordDependency, targetDate: Date) {
        self.targetDate = targetDate
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RecordBuildable: Buildable {
    func build(withListener listener: RecordListener, targetDate: Date) -> RecordRouting
}

final class RecordBuilder: Builder<RecordDependency>, RecordBuildable {

    override init(dependency: RecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordListener, targetDate: Date) -> RecordRouting {
        let component = RecordComponent(dependency: dependency, targetDate: targetDate)
        let viewController = RecordViewController()
        viewController.hidesBottomBarWhenPushed = true
        let interactor = RecordInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return RecordRouter(interactor: interactor, viewController: viewController)
    }
}
