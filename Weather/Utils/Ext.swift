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
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, YYYY"
        return formatter.string(from: self)
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
    
    var dateTimeText: String {
        return "\(dateText) at \(timeText)"
    }
}

extension String {
    var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self)
        return date?.weekdayText ?? ""
    }
    
    var dateTimeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.date(from: self)
        return date?.dateTimeText ?? ""
    }
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self)
        return date?.dateText ?? ""
    }
    
    var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.date(from: self)
        return date?.timeText ?? ""
    }
}

extension Float {
    var temperatureText: String {
        return "\(self)°"
    }
}
