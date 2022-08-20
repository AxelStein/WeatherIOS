//
//  GetForecastInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 16.08.2022.
//

import Foundation

class GetDailyForecastInteractor {
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
                handler(nil)
            }
        }
    }
    
    private func parseDailyForecast(_ data: Data) -> DailyForecast? {
        return try! JSONDecoder().decode(DailyForecast.self, from: data)
    }
}
