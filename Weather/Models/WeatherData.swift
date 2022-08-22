//
//  WeatherData.swift
//  Weather
//
//  Created by Александр Шерий on 15.08.2022.
//

import Foundation
import UIKit
import RealmSwift

struct ApiError: Error, Codable {
    let statusCode: Int
    let statusMessage: String
}

struct CurrentWeather: Codable {
    let count: Int
    let data: [ForecastData]
}

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
    let cityName: String
    let countryCode: String
    let data: [ForecastData]
}

struct ForecastData: Codable {
    let date: Date
    let temp: Float
    let minTemp: Float
    let maxTemp: Float
    let feelsLikeTemp: Float
    let windSpeed: Float // m/s
    let windDirection: String
    let windDirectionFull: String
    let sunrise: Date
    let sunset: Date
    let weather: WeatherDetail
    let precipitationProbability: Int // %
    let precipitation: Float // Accumulated liquid equivalent precipitation (default mm)
    let accumulatedSnowfall: Float // default mm/h
    let averageRelativeHumidity: Float // %
    let averageCloudCoverage: Int // %
    let visibility: Float // km
    let ultraVioletIndex: Float
    let averagePressure: Float // mb
    let airQualityIndex: Int
    let lastObservationDateTime: Date
    
    enum CodingKeys: String, CodingKey {
        case date = "validDate"
        case temp
        case minTemp
        case maxTemp
        case feelsLikeTemp = "appTemp"
        case windSpeed = "windSpd"
        case windDirection = "windCdir"
        case windDirectionFull = "windCdirFull"
        case sunrise = "sunriseTs"
        case sunset = "sunsetTs"
        case weather
        case precipitationProbability = "pop"
        case precipitation = "precip"
        case accumulatedSnowfall = "snow"
        case averageRelativeHumidity = "rh"
        case averageCloudCoverage = "clouds"
        case visibility = "vis"
        case ultraVioletIndex = "uv"
        case averagePressure = "pres"
        case airQualityIndex = "aqi"
        case lastObservationDateTime = "obTime"
    }
}

extension ForecastData {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateStr = try values.decodeIfPresent(String.self, forKey: .date) ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date = formatter.date(from: dateStr) ?? Date()
        
        let obDt = try values.decodeIfPresent(String.self, forKey: .lastObservationDateTime) ?? ""
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        lastObservationDateTime = formatter.date(from: obDt) ?? Date()
        
        let sunriseTs = try values.decodeIfPresent(Int64.self, forKey: .sunrise) ?? 0
        sunrise = Date(timeIntervalSince1970: TimeInterval(sunriseTs))
        
        let sunsetTs = try values.decodeIfPresent(Int64.self, forKey: .sunset) ?? 0
        sunset = Date(timeIntervalSince1970: TimeInterval(sunsetTs))
        
        temp = try values.decodeIfPresent(Float.self, forKey: .temp) ?? 0
        minTemp = try values.decodeIfPresent(Float.self, forKey: .minTemp) ?? 0
        maxTemp = try values.decodeIfPresent(Float.self, forKey: .maxTemp) ?? 0
        feelsLikeTemp = try values.decodeIfPresent(Float.self, forKey: .feelsLikeTemp) ?? 0
        windSpeed = try values.decodeIfPresent(Float.self, forKey: .windSpeed) ?? 0
        windDirection = try values.decodeIfPresent(String.self, forKey: .windDirection) ?? ""
        windDirectionFull = try values.decodeIfPresent(String.self, forKey: .windDirectionFull) ?? ""
        
        weather = try values.decodeIfPresent(WeatherDetail.self, forKey: .weather) ?? WeatherDetail(icon: "", code: 0, description: "")
        precipitationProbability = try values.decodeIfPresent(Int.self, forKey: .precipitationProbability) ?? 0
        precipitation = try values.decodeIfPresent(Float.self, forKey: .precipitation) ?? 0
        accumulatedSnowfall = try values.decodeIfPresent(Float.self, forKey: .accumulatedSnowfall) ?? 0
        averageRelativeHumidity = try values.decodeIfPresent(Float.self, forKey: .averageRelativeHumidity) ?? 0
        averageCloudCoverage = try values.decodeIfPresent(Int.self, forKey: .averageCloudCoverage) ?? 0
        visibility = try values.decodeIfPresent(Float.self, forKey: .visibility) ?? 0
        ultraVioletIndex = try values.decodeIfPresent(Float.self, forKey: .ultraVioletIndex) ?? 0
        averagePressure = try values.decodeIfPresent(Float.self, forKey: .averagePressure) ?? 0
        airQualityIndex = try values.decodeIfPresent(Int.self, forKey: .airQualityIndex) ?? 0
    }
}

enum ForecastDetailItem {
    case temperature(value: Float)
    case wind(speed: Float, direction: String)
    case precipitationProbability(value: Int)
    case precipitation(value: Float)
    case humidity(value: Float)
    case clouds(value: Int)
    case snow(value: Float)
    case sunrise(value: Date)
    case sunset(value: Date)
    case visibility(value: Float)
    case ultravioletIndex(value: Float)
    case pressure(value: Float)
}

extension ForecastDetailItem {
    var icon: UIImage {
        switch self {
        case .temperature:
            return UIImage(systemName: "thermometer")!
        case .wind:
            return UIImage(systemName: "wind")!
        case .precipitationProbability:
            return UIImage(systemName: "cloud.rain")!
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
        case .visibility:
            return UIImage(systemName: "eye")!
        case .ultravioletIndex:
            return UIImage(systemName: "light.max")!
        case .pressure:
            return UIImage(systemName: "barometer")!
        }
    }
    
    var title: String {
        switch self {
        case .temperature:
            return "Average temperature"
        case .wind:
            return "Wind"
        case .precipitationProbability:
            return "Probability of precipitations"
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
        case .visibility:
            return "Visibility"
        case .ultravioletIndex:
            return "Ultraviolet index"
        case .pressure:
            return "Pressure"
        }
    }
    
    var detail: String {
        switch self {
        case .temperature(let value):
            return "\(value)°"
        case .wind(let speed, let direction):
            return "\(speed) m/s \(direction)"
        case .precipitationProbability(let value):
            return "\(value)%"
        case .precipitation(let value):
            return "\(Int(value)) mm"
        case .humidity(let value):
            return "\(value)%"
        case .clouds(let value):
            return "\(value)%"
        case .snow(let value):
            return "\(value) mm/h"
        case .sunrise(let value):
            return value.timeText
        case .sunset(let value):
            return value.timeText
        case .visibility(let value):
            return "\(Int(value)) km"
        case .ultravioletIndex(let value):
            return "\(value)"
        case .pressure(let value):
            return "\(value) mb"
        }
    }
}
