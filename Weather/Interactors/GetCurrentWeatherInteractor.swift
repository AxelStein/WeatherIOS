//
//  GetCurrentWeatherInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

class GetCurrentWeatherInteractor {
    private let dataLoader = DataLoader()
    
    func invoke(location: Location, handler: @escaping (CurrentWeather?) -> Void) {
        dataLoader.request(endpoint: .getCurrentWeather(location: location), handler: { result in
            var weather: CurrentWeather? = nil
            do {
                weather = try self.parseData(result.get())
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                handler(weather)
            }
        })
    }
    
    private func parseData(_ data: Data) -> CurrentWeather? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(CurrentWeather.self, from: data)
        } catch let error {
            print(error)
        }
        return nil
    }
}
