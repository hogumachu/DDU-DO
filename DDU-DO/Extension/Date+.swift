//
//  Date+.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/02/11.
//

import Foundation

extension Date {
    
    var isDateInToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var dayOfWeek: Int? {
        let calendar = Calendar.current
        return calendar.dateComponents([.weekday], from: self).weekday
    }
    
}
