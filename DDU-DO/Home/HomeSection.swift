//
//  HomeSection.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation

enum HomeSection {
    case todo([HomeItem])
    
    var items: [HomeItem] {
        switch self {
        case .todo(let items):
            return items
        }
    }
}

enum HomeItem {
    case title(String)
    case todo(HomeTodoTableViewCellModel, targetDate: Date)
}
