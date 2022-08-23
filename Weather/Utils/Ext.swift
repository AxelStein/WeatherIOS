//
//  DateExt.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation
import UIKit

extension Locale {
    static var is24Hour: Bool {
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return dateFormat.firstIndex(of: "a") == nil
    }
}

extension Date {
    var weekdayAbbrText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    var weekdayText: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1].capitalized
    }
    
    var dateShortText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
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
        return "\(dateText) \("at"~) \(timeText)"
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

extension UIViewController {
    func showActivityIndicator() {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.center = self.view.center
        self.view.addSubview(activity)
        activity.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.view.subviews.forEach {
            if $0 is UIActivityIndicatorView {
                $0.removeFromSuperview()
            }
        }
    }
    
    func showActivityIndicatorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "loading"~, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
                
        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
                
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
                
        present(alert, animated: true)
        return alert
    }
}

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
