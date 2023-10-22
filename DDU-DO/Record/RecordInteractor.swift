//
//  RecordInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/22.
//

import Foundation
import RIBs
import RxSwift

protocol RecordRouting: ViewableRouting {
    
}

protocol RecordPresentable: Presentable {
    var listener: RecordPresentableListener? { get set }
}

protocol RecordListener: AnyObject {
    func recordDidFinishRecord(target: Date)
}

protocol RecordInteractorDependency: Dependency {
    var todoUseCase: TodoUseCase { get }
    var targetDate: Date { get }
}

final class RecordInteractor: PresentableInteractor<RecordPresentable>, RecordInteractable, RecordPresentableListener {
    
    weak var router: RecordRouting?
    weak var listener: RecordListener?
    
    private let dependency: RecordInteractorDependency
    private var text: String = ""
    
    init(
        presenter: RecordPresentable,
        dependency: RecordInteractorDependency
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
        guard text.isEmpty == false else { return }
        let entity = TodoEntity(
            todo: text,
            isComplete: false,
            createAt: Date(),
            targetDate: dependency.targetDate
        )
        do {
            try dependency.todoUseCase.insert(item: entity)
            listener?.recordDidFinishRecord(target: dependency.targetDate)
        } catch {
            print("# Handle Error")
        }
    }
    
    
}
