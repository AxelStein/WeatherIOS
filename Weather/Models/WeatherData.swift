//
//  WeatherData.swift
//  Weather
//
//  Created by Александр Шерий on 15.08.2022.
//

import Foundation

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

struct ForecastData: Codable {
    let valid_date: String
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let wind_spd: Float
    let wind_cdir_full: String
    let sunrise_ts: Int64
    let sunset_ts: Int64
    let weather: WeatherDetail
}
