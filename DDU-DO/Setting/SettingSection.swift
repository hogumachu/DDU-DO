//
//  SettingSection.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation

enum SettingSection {
    
    case setting([SettingItem])
    
    var items: [SettingItem] {
        switch self {
        case .setting(let items):       return items
        }
    }
    
}

enum SettingItem {
    
    case title(SettingTableViewCellModel)
    case detail(SettingTableViewCellModel)
    
}
