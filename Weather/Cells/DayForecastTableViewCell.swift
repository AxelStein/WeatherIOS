//
//  DayForecastTableViewCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    func setForecast(_ data: ForecastData) {
        weekDayLabel.text = data.valid_date?.weekdayText
        maxTempLabel.text = data.max_temp?.temperatureText
        minTempLabel.text = data.min_temp?.temperatureText
        weatherIconView.load(src: data.weather.iconURL)
    }
}
