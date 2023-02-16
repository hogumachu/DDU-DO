//
//  SettingViewModel.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/15.
//

import Foundation
import RxSwift
import RxRelay
import Then

enum SettingViewModelEvent {
    
    case reloadData
    case showModalView(BottomModalViewModel)
    case didFinish(message: String?)
    case didFail(message: String?)
    
}

final class SettingViewModel {
    
    enum Section {
        
        case setting([Item])
        
        var items: [Item] {
            switch self {
            case .setting(let items):       return items
            }
        }
        
    }
    
    enum Item {
        
        case title(SettingTableViewCellModel)
        case detail(SettingTableViewCellModel)
        
    }
    
    init(todoRepository: TodoRepository<TodoEntity>) {
        self.todoRepository = todoRepository
        self.sections = self.makeSections(settings: self.settings)
        self.viewModelEventRelay.accept(.reloadData)
    }
    
    var viewModelEvent: Observable<SettingViewModelEvent> {
        self.viewModelEventRelay.asObservable()
    }
    
    var numberOfSections: Int {
        self.sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.sections[safe: section]?.items.count ?? 0
    }
    
    func cellItem(at indexPath: IndexPath) -> Item? {
        guard let section = self.sections[safe: indexPath.section] else { return nil }
        return section.items[safe: indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let setting = self.settings[safe: indexPath.row] else { return }
        
        switch setting {
        case .appVersion:
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id~~~~~~~~~~~") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case .deleteAll:
            let modalViewModel = BottomModalViewModel(title: "정말 제거하시겠습니까?", subtitle: "제거하시면 다시는 복구할 수 없어요", buttonTitle: "제거하기", cancelButtonTitle: "취소", type: .alert)
            self.viewModelEventRelay.accept(.showModalView(modalViewModel))
            
        case .review:
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id~~~~~~~~~~~") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case .mail:
            self.mailToDeveloperIfEnabled()
        }
    }
    
    func bottomModalViewButtonDidTap() {
        do {
            try self.todoRepository.deleteAll()
            self.viewModelEventRelay.accept(.didFinish(message: "성공적으로 제거했습니다"))
        } catch {
            self.viewModelEventRelay.accept(.didFail(message: "데이터 제거에 실패했습니다"))
        }
    }
    
    private func mailToDeveloperIfEnabled() {
        let address = "hogumachu@gmail.com"
        let title = "뚜두 문의사항"
        let appVersion = "AppVersion: " + AppBundle.appVersion
        let device = UIDevice.current.modelName
        let os = UIDevice.current.systemVersion
        
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = address
        components.queryItems = [
            URLQueryItem(name: "subject", value: title),
            URLQueryItem(name: "body", value: "\n\n\n\n\n---------------\n\n\n" + [appVersion, device, os].joined(separator: "\n"))
        ]
        guard let url = components.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func makeSections(settings: [Setting]) -> [Section] {
        let items = settings.map { setting -> Item in
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
    
    private let settings: [Setting] = [.appVersion, .review, .mail, .deleteAll]
    private var sections: [Section] = []
    private let todoRepository: TodoRepository<TodoEntity>
    
    private let viewModelEventRelay = PublishRelay<SettingViewModelEvent>()
    
}
