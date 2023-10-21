//
//  SettingInteractor.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation
import RIBs
import RxSwift

protocol SettingRouting: ViewableRouting {
    
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
    func updateSections(_ sections: [SettingSection])
}

protocol SettingListener: AnyObject {
    func settingDidTapClose()
}

protocol SettingInteractorDependency: Dependency {
    var todoUsease: TodoUseCase { get }
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>, SettingInteractable, SettingPresentableListener {
    
    weak var router: SettingRouting?
    weak var listener: SettingListener?
    
    private let dependency: SettingInteractorDependency
    private let settings: [Setting] = [.appVersion, .review, .mail, .deleteAll]
    
    init(
        presenter: SettingPresentable, dependency: SettingInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.updateSections(makeSections(settings: settings))
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapClose() {
        listener?.settingDidTapClose()
    }
    
    func didSelect(at indexPath: IndexPath) {
        
    }
    
    private func makeSections(settings: [Setting]) -> [SettingSection] {
        let items = settings.map { setting -> SettingItem in
            switch setting {
            case .appVersion:
                return .detail(.init(title: "앱 버전", subtitle: AppBundle.appVersion))
                
            case .deleteAll:
                return .title(.init(title: "데이터 모두 제거하기", subtitle: nil))
                
            case .mail:
                return .detail(.init(title: "문의하기", subtitle: nil))
                
            case .review:
                return .detail(.init(title: "리뷰쓰기", subtitle: nil))
            }
        }
        return [.setting(items)]
    }
    
}
