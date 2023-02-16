//
//  Date+Weekday.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import Foundation

enum Weekday: Int, CaseIterable {
    
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    func toString() -> String {
        switch self {
        case .sunday:       return "일"
        case .monday:       return "월"
        case .tuesday:      return "화"
        case .wednesday:    return "수"
        case .thursday:     return "목"
        case .friday:       return "금"
        case .saturday:     return "토"
        }
    }
}


extension Date {
    
    var weekday: Weekday? {
        guard let dayOfWeek = self.dayOfWeek else { return nil }
        return Weekday(rawValue: dayOfWeek)
    }
    
}
