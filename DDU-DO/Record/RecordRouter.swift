//
//  RecordRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs

protocol RecordInteractable: Interactable {
    var router: RecordRouting? { get set }
    var listener: RecordListener? { get set }
}

protocol RecordViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RecordRouter: ViewableRouter<RecordInteractable, RecordViewControllable>, RecordRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RecordInteractable, viewController: RecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
