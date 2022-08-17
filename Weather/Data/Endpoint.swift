//
//  Endpoint.swift
//  Weather
//
//  Created by Александр Шерий on 17.08.2022.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func getDailyForecast(location: Location) -> Endpoint {
        return Endpoint(
            path: "/v2.0/forecast/daily",
            queryItems: [
                URLQueryItem(name: "lang", value: "ru"),
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "days", value: "7"),
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
