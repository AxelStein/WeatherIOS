//
//  Endpoint.swift
//  Weather
//
//  Created by Александр Шерий on 17.08.2022.
//

import Foundation

let key = "5a62cec1882c4e55b2a6ce59cfa31ffd"

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func getDailyForecast(location: Location) -> Endpoint {
        return Endpoint(
            path: "/v2.0/forecast/daily",
            queryItems: [
                URLQueryItem(name: "lang", value: Locale.current.languageCode ?? "en"),
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "days", value: "10"),
                URLQueryItem(name: "lat", value: String(location.lat)),
                URLQueryItem(name: "lon", value: String(location.lon)),
            ]
        )
    }
    
    static func getCurrentWeather(location: Location) -> Endpoint {
        return Endpoint(
            path: "/v2.0/current",
            queryItems: [
                URLQueryItem(name: "lang", value: Locale.current.languageCode ?? "en"),
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "lat", value: String(location.lat)),
                URLQueryItem(name: "lon", value: String(location.lon)),
            ]
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherbit.io"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
