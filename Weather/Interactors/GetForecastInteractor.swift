//
//  GetForecastInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 24.08.2022.
//

import UIKit
import CoreData
import Combine

class GetForecastInteractor {
    private let jsonDecoder = JSONDecoder()
    private let getForecastModel = GetForecastModelInteractor()
    private let saveForecastModel = SaveForecastModelInteractor()
    private var cancellable: AnyCancellable? = nil
    
    init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func invoke(location: LocationModel, handler: @escaping (Result<(CurrentWeather, DailyForecast), Error>) -> Void) {
        if let forecastModel = getForecastModel.invoke(location: location) {
            handler(.success(forecastModel))
            return
        }
        
        let getCurrentWeatherUrl = Endpoint.getCurrentWeather(location: location).url!
        let currentWeatherPublisher = URLSession.shared.dataTaskPublisher(for: getCurrentWeatherUrl)
        
        let getDailyForecastUrl = Endpoint.getDailyForecast(location: location).url!
        let getDailyForecastPublisher = URLSession.shared.dataTaskPublisher(for: getDailyForecastUrl)
        
        self.cancellable = Publishers.Zip(currentWeatherPublisher, getDailyForecastPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    handler(.failure(error))
                case .finished:
                    do {}
                }
            }, receiveValue: { currentWeatherOutput, dailyForecastOutput in
                
                let currentWeatherData = currentWeatherOutput.data
                let dailyForecastData = dailyForecastOutput.data
                
                self.saveForecastModel.invoke(
                    location: location,
                    currentWeatherData: currentWeatherData,
                    dailyForecastData: dailyForecastData
                )
                
                if let currentWeather = try? self.jsonDecoder.decode(CurrentWeather.self, from: currentWeatherData),
                   let dailyForecast = try? self.jsonDecoder.decode(DailyForecast.self, from: dailyForecastData) {
                    handler(.success((currentWeather, dailyForecast)))
                } else if let apiError = try? self.jsonDecoder.decode(ApiError.self, from: currentWeatherData) {
                    handler(.failure(apiError))
                } else if let apiError = try? self.jsonDecoder.decode(ApiError.self, from: dailyForecastData) {
                    handler(.failure(apiError))
                } else {
                    handler(.failure(ApiError(statusCode: 0, statusMessage: "Unknown error")))
                }
            })
    }
}
