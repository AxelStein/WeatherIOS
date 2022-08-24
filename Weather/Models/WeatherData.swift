//
//  WeatherData.swift
//  Weather
//
//  Created by Александр Шерий on 15.08.2022.
//

import Foundation
import UIKit

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
