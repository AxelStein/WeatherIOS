//
//  ForecastDetailItem.swift
//  Weather
//
//  Created by Александр Шерий on 24.08.2022.
//

import Foundation
import UIKit

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
            return "wind"~
        case .precipitationProbability:
            return "precipitationProbability"~
        case .precipitation:
            return "precipitation"~
        case .humidity:
            return "humidity"~
        case .clouds:
            return "clouds"~
        case .snow:
            return "snow"~
        case .sunrise:
            return "sunrise"~
        case .sunset:
            return "sunset"~
        case .visibility:
            return "visibility"~
        case .ultravioletIndex:
            return "ultravioletIndex"~
        case .pressure:
            return "pressure"~
        }
    }
    
    var detail: String {
        switch self {
        case .temperature(let value):
            return "\(value)°"
        case .wind(let speed, let direction):
            return "\(speed) \("m/s"~) \(direction)"
        case .precipitationProbability(let value):
            return "\(value)%"
        case .precipitation(let value):
            return "\(Int(value)) \("mm"~)"
        case .humidity(let value):
            return "\(value)%"
        case .clouds(let value):
            return "\(value)%"
        case .snow(let value):
            return "\(value) \("mm/h"~)"
        case .sunrise(let value):
            return value.timeText
        case .sunset(let value):
            return value.timeText
        case .visibility(let value):
            return "\(Int(value)) \("km"~)"
        case .ultravioletIndex(let value):
            return "\(value)"
        case .pressure(let value):
            return "\(value) \("mb"~)"
        }
    }
}
