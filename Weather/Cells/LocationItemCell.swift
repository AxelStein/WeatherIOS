//
//  LocationItemCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class LocationItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setItem(_ location: LocationModel) {
        let countryCode = location.countryCode ?? ""
        let title = location.title ?? ""
        if countryCode.isEmpty {
            titleLabel.text = title
        } else {
            titleLabel.text = "\(flag(country: countryCode))    \(title)"
        }
    }
    
    private func flag(country: String) -> String {
        if country.isEmpty {
            return ""
        }
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
