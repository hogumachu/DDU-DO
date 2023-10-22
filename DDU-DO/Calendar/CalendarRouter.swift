//
//  CalendarRouter.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs

protocol CalendarInteractable: Interactable {
    var router: CalendarRouting? { get set }
    var listener: CalendarListener? { get set }
}

protocol CalendarViewControllable: ViewControllable {}

final class CalendarRouter: ViewableRouter<CalendarInteractable, CalendarViewControllable>, CalendarRouting {
    
    override init(interactor: CalendarInteractable, viewController: CalendarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
