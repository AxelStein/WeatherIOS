//
//  DateExt.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

extension Date {
    var weekdayText: String {
        /*
        print(self)
        if Calendar.current.isDateInToday(self) {
            return "Today"
        }
        if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow"
        }
        */
        let weekday = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1].capitalized
    }
}
