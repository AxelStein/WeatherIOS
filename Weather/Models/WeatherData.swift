//
//  WeatherData.swift
//  Weather
//
//  Created by Александр Шерий on 15.08.2022.
//

import Foundation
import UIKit

struct WeatherDetail: Codable {
    let icon: String
    let code: Int
    let description: String
}

extension WeatherDetail {
    var iconURL: String {
        return "https://www.weatherbit.io/static/img/icons/\(icon).png"
    }
}

struct DailyForecast: Codable {
    let city_name: String
    let country_code: String
    let data: [ForecastData]
}

struct HourlyForecast: Codable {
    let data: [ForecastData]
}

struct ForecastData: Codable {
    let valid_date: String?
    let timestamp_utc: String?
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let wind_spd: Float // Wind speed (Default m/s)
    let wind_cdir: String // Wind direction
    let wind_cdir_full: String // Verbal wind direction
    let sunrise_ts: Int64
    let sunset_ts: Int64
    let weather: WeatherDetail
    let pop: Int // Probability of Precipitation (%)
    let snow: Int // Accumulated snowfall (default mm)
    let snow_depth: Int // Snow Depth (default mm)
    let rh: Int // Average relative humidity (%)
    let clouds: Int // Average total cloud coverage (%)
}

extension ForecastData {
    var sunriseDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self.sunrise_ts))
    }
    
    var sunsetDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self.sunset_ts))
    }
}

enum ForecastDetailItem {
    case temperature(value: Float)
    case wind(speed: Float, direction: String)
    case precipitation(value: Int)
    case humidity(value: Int)
    case clouds(value: Int)
    case snow(value: Int)
    case sunrise(value: Date)
    case sunset(value: Date)
}

extension ForecastDetailItem {
    var icon: UIImage {
        switch self {
        case .temperature:
            return UIImage(systemName: "thermometer")!
        case .wind:
            return UIImage(systemName: "wind")!
        case .precipitation:
            return UIImage(systemName: "cloud.rain")!
        case .humidity:
            return UIImage(systemName: "humidity")!
        case .clouds:
            return UIImage(systemName: "cloud")!
        case .snow:
            return UIImage(systemName: "cloud.snow")!
        case .sunrise:
            return UIImage(systemName: "sunrise")!
        case .sunset:
            return UIImage(systemName: "sunset")!
        }
    }
    
    var title: String {
        switch self {
        case .temperature:
            return "Average temperature"
        case .wind:
            return "Wind"
        case .precipitation:
            return "Precipitations"
        case .humidity:
            return "Humidity"
        case .clouds:
            return "Clouds"
        case .snow:
            return "Snow"
        case .sunrise:
            return "Sunrise"
        case .sunset:
            return "Sunset"
        }
    }
    
    var detail: String {
        switch self {
        case .temperature(let value):
            return "\(value)°"
        case .wind(let speed, let direction):
            return "\(speed) m/s \(direction)"
        case .precipitation(let value):
            return "\(value)%"
        case .humidity(let value):
            return "\(value)%"
        case .clouds(let value):
            return "\(value)%"
        case .snow(let value):
            return "\(value) mm"
        case .sunrise(let value):
            return value.timeText
        case .sunset(let value):
            return value.timeText
        }
    }
}
