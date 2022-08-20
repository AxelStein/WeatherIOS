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
            do {
                let weather = try self.parseData(result.get())
                DispatchQueue.main.async {
                    handler(weather)
                }
            } catch let error {
                print(error)
            }
        })
    }
    
    private func parseData(_ data: Data) -> CurrentWeather {
        return try! JSONDecoder().decode(CurrentWeather.self, from: data)
    }
}
