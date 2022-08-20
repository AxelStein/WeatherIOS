//
//  DateExt.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

extension Locale {
    static var is24Hour: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
}

extension Date {
    var weekdayText: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1].capitalized
    }
    
    var timeText: String {
        let formatter = DateFormatter()
        if Locale.is24Hour {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "hh:mm aa"
        }
        return formatter.string(from: self)
    }
}
