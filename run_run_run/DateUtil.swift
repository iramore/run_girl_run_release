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
    
    
}
