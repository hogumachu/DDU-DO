//
//  CalendarCalculator.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/30.
//

import Foundation

final class CalendarCalculator {
    
    func year(from: Date) -> Int {
        self.calendar.component(.year, from: from)
    }
    
    func month(from: Date) -> Int {
        self.calendar.component(.month, from: from)
    }
    
    func day(from: Date) -> Int {
        self.calendar.component(.day, from: from)
    }
    
    func date(year: Int, month: Int, day: Int) -> Date? {
        self.calendar.date(from: DateComponents(year: year, month: month, day: day))
    }
    
    func date(byAddingDayValue value: Int, to base: Date) -> Date? {
        self.calendar.date(byAdding: .day, value: value, to: base)
    }
    
    func date(byAddingMonthValue value: Int, to base: Date) -> Date? {
        self.calendar.date(byAdding: .month, value: value, to: base)
    }
    
    func isEqualYearAndMonth(_ compare1: Date, _ compare2: Date) -> Bool {
        self.year(from: compare1) == self.year(from: compare2) && self.month(from: compare1) == self.month(from: compare2)
    }
    
    private let calendar = Calendar(identifier: .gregorian)
    
}
