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
    @IBOutlet weak var aqiButton: UIButton!
    
    func setCurrentWeather(_ weather: CurrentWeather) {
        guard let data = weather.data.first else { return }
        weatherDescriptionLabel.text = data.weather.description
        tempLabel.text = data.temp.temperatureText
        weatherIconView.load(src: data.weather.iconURL)
        observationTimeLabel.text = "\(data.lastObservationDateTime.dateTimeText)"
        let aqi = data.airQualityIndex
        aqiButton.setTitle("\("aqi"~) \(aqi)", for: .normal)
        switch aqi {
        case 0...50:
            aqiButton.setTint(UIColor.systemGreen)
        case 51...100:
            aqiButton.setTint(UIColor.systemYellow)
        case 101...150:
            aqiButton.setTint(UIColor.systemOrange)
        case 151...200:
            aqiButton.setTint(UIColor.systemRed)
        case 201...300:
            aqiButton.setTint(UIColor.systemPurple)
        default:
            aqiButton.setTint(UIColor.systemIndigo)
        }
    }
}

private extension UIButton {
    func setTint(_ color: UIColor) {
        tintColor = color
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
}
