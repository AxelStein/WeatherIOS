//
//  ForecastSummaryItemCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class ForecastSummaryItemCell: UITableViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    func setForecastData(_ data: ForecastData) {
        minLabel.text = "min"~
        maxLabel.text = "max"~
        tempLabel.text = data.temp.temperatureText
        iconView.load(src: data.weather.iconURL)
        descriptionLabel.text = data.weather.description
        minTempLabel.text = data.minTemp.temperatureText
        maxTempLabel.text = data.maxTemp.temperatureText
    }
}
