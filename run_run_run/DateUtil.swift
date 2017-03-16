//
//  DateUtil.swift
//  run_run_run
//
//  Created by infuntis on 08.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation

class DateUtil: NSObject {
    
    static func dayOfWeekToCurrentLocale(date: Date)-> Int{
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Locale.current.languageCode!)
        let weekDay = calendar.component(.weekday, from: date)
        return (weekDay + 7 - calendar.firstWeekday)%7 + 1
        
    }
    
    static func getConvertedToday()-> Date{
        let date = Date()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Locale.current.languageCode!)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var components = DateComponents()
        components.setValue(month, for: .month)
        components.setValue(year, for: .year)
        components.setValue(day, for: .day)
        return Calendar.current.date(from: components)!
    }
    
    
}
