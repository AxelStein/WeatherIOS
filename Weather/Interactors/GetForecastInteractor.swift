//
//  GetForecastInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 16.08.2022.
//

import Foundation

let key = "5a62cec1882c4e55b2a6ce59cfa31ffd"

func createUrlComponents(path: String) -> URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.weatherbit.io"
    components.path = path
    return components
}

// https://www.weatherbit.io/static/img/icons/t01d.png
class GetForecastInteractor {
    private let dataLoader = DataLoader()
    
    func invoke(location: Location, handler: @escaping (DailyForecast?) -> Void) {
        dataLoader.request(endpoint: .getDailyForecast(location: location)) { result in
            do {
                let forecast = try self.parseDailyForecast(result.get())
                DispatchQueue.main.async {
                    handler(forecast)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func parseDailyForecast(_ data: Data) -> DailyForecast? {
        return try! JSONDecoder().decode(DailyForecast.self, from: data)
    }
}
