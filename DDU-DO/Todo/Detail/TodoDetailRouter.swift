//
//  TodoDetailRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs

protocol TodoDetailInteractable: Interactable {
    var router: TodoDetailRouting? { get set }
    var listener: TodoDetailListener? { get set }
}

protocol TodoDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TodoDetailRouter: ViewableRouter<TodoDetailInteractable, TodoDetailViewControllable>, TodoDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TodoDetailInteractable, viewController: TodoDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
