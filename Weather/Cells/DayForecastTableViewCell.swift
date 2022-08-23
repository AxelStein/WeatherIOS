//
//  DayForecastTableViewCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var weekDayLabel: UILabel!
    
    func setForecast(_ data: ForecastData) {
        weekDayLabel.text = "\(data.date.weekdayAbbrText) • \(data.date.dateShortText)"
        tempLabel.text = "\(data.minTemp.temperatureText ) / \(data.maxTemp.temperatureText)"
        weatherIconView.load(src: data.weather.iconURL)
    }
}
