//
//  ViewController.swift
//  Weather
//
//  Created by Александр Шерий on 14.08.2022.
//

import UIKit

class ForecastViewController: UIViewController {
    private let locationLutsk = Location(lat: 50.7482711757513, lon: 25.329339998846542)

    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var nowWeatherSummaryLabel: UILabel!
    @IBOutlet weak var nowStackView: UIStackView!
    @IBOutlet weak var nowWeatherIconView: UIImageView!
    private let getForecast = GetForecastInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowTempLabel.text = ""
        nowWeatherSummaryLabel.text = ""
        
        getForecast.invoke(location: locationLutsk) { dailyForecast in
            if let dailyForecast = dailyForecast {
                self.setDailyForecast(dailyForecast)
            }
        }
    }
    
    private func setDailyForecast(_ dailyForecast: DailyForecast) {
        guard let weatherData = dailyForecast.data.first else { return }
        nowWeatherSummaryLabel.text = weatherData.weather.description
        nowTempLabel.text = "\(weatherData.temp ) °C"
        nowWeatherIconView.load(src: weatherData.weather.iconURL)
    }
}
