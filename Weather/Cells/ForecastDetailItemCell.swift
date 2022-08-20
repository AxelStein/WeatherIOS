//
//  WeatherDetailCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class ForecastDetailItemCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func setItem(_ item: ForecastDetailItem) {
        iconView.image = item.icon
        titleLabel.text = item.title
        detailLabel.text = item.detail
    }
}
