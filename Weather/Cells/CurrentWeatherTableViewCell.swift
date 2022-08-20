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
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setForecast(_ forecast: DailyForecast) {
        guard let weatherData = forecast.data.first else { return }
        cityLabel.text = forecast.city_name
        weatherDescriptionLabel.text = weatherData.weather.description
        tempLabel.text = "\(weatherData.temp)°"
        weatherIconView.load(src: weatherData.weather.iconURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
