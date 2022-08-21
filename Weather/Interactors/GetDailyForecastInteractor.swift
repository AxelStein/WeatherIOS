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
            var forecast: DailyForecast? = nil
            do {
                forecast = try self.parseDailyForecast(result.get())
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                handler(forecast)
            }
        }
    }
    
    private func parseDailyForecast(_ data: Data) -> DailyForecast? {
        do {
            return try JSONDecoder().decode(DailyForecast.self, from: data)
        } catch let error {
            print(error)
        }
        return nil
    }
}
