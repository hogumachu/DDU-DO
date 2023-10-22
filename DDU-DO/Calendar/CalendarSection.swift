//
//  CalendarSection.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import Foundation

enum CalendarSection {
    case content([CalendarItem])
    
    var items: [CalendarItem] {
        switch self {
        case .content(let items):       return items
        }
    }
}

struct CalendarItem {
    let model: CalendarListTableViewCellModel
    let createdAt: Date
}
