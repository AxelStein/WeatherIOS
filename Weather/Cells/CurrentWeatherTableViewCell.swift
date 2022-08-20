//
//  CurrentWeatherTableViewCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var observationTimeLabel: UILabel!
    
    func setCurrentWeather(_ weather: CurrentWeather) {
        guard let data = weather.data.first else { return }
        weatherDescriptionLabel.text = data.weather.description
        tempLabel.text = data.temp.temperatureText
        weatherIconView.load(src: data.weather.iconURL)
        observationTimeLabel.text = "\(data.ob_time?.dateTimeText ?? "")"
    }
}
