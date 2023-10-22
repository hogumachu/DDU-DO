//
//  TodoDetailInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import RIBs
import RxSwift

protocol TodoDetailRouting: ViewableRouting {}

protocol TodoDetailPresentable: Presentable {
    var listener: TodoDetailPresentableListener? { get set }
}

protocol TodoDetailListener: AnyObject {
    func todoDetailDidFinish()
}

protocol TodoDetailInteractorDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var entity: TodoEntity { get }
}

final class TodoDetailInteractor: PresentableInteractor<TodoDetailPresentable>, TodoDetailInteractable, TodoDetailPresentableListener {
    
    weak var router: TodoDetailRouting?
    weak var listener: TodoDetailListener?
    
    private let dependency: TodoDetailInteractorDependency
    private lazy var text: String = dependency.entity.todo
    
    init(
        presenter: TodoDetailPresentable,
        dependency: TodoDetailInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func textUpdated(_ text: String) {
        self.text = text
    }
    
    func didTapConfirm() {
        let entity = TodoEntity(
            todo: text,
            isComplete: dependency.entity.isComplete,
            createAt: dependency.entity.createAt,
            targetDate: dependency.entity.targetDate
        )
        do {
            try dependency.todoUseCase.update(item: entity)
            listener?.todoDetailDidFinish()
        } catch {
            print("# ERROR: \(error.localizedDescription)")
        }
    }
    
}
