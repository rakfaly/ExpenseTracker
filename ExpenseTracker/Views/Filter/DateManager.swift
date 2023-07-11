//
//  DateManager.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 08/07/2023.
//

import Foundation


struct DateManager {
    let components = Calendar.current.dateComponents([.year, .month], from: Date())
    var firstDayComponents = DateComponents()
    
    init() {
        firstDayComponents.year = components.year
        firstDayComponents.month = components.month
        firstDayComponents.day = 1
    }
    
    func getMonth(byAdding month: Int) -> (startDate: Date, endDate: Date){
        let startDate = Calendar.current.date(from: firstDayComponents) ?? Date()
        let endDate = Calendar.current.date(byAdding: .month, value: month, to: startDate) ?? Date()
        return (startDate: startDate, endDate: endDate)
    }
    
    func getYear(byAdding year: Int) -> (startDate: Date, endDate: Date) {
        let thisYear = Calendar.current.dateComponents([.year], from: Date())
        let startDate = Calendar.current.date(from: thisYear) ?? Date()
        let endDate = Calendar.current.date(byAdding: .year, value: year, to: startDate) ?? Date()
        return (startDate: startDate, endDate: endDate)
    }
    
    func getNarrowDates(beginDate: Date, endDate: Date) -> (startDate: Date, endDate: Date) {
        guard let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) else {
            return (startDate: beginDate, endDate: endDate)
        }
        return (startDate: beginDate, endDate: endOfDay)
    }
    
}
