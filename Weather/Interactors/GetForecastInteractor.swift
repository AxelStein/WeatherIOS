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
            print("### get from core data \(location.title)")
            handler(.success(forecastModel))
            return
        }
        
        let getCurrentWeatherUrl = Endpoint.getCurrentWeather(location: location).url!
        let currentWeatherPublisher = URLSession.shared.dataTaskPublisher(for: getCurrentWeatherUrl)
        
        let getDailyForecastUrl = Endpoint.getDailyForecast(location: location).url!
        let getDailyForecastPublisher = URLSession.shared.dataTaskPublisher(for: getDailyForecastUrl)
        
        self.cancellable = Publishers.Zip(currentWeatherPublisher, getDailyForecastPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { currentWeatherOutput, dailyForecastOutput in
                print("### fetch from network \(location.title)")
                
                let currentWeatherData = currentWeatherOutput.data
                let dailyForecastData = dailyForecastOutput.data
                
                self.saveForecastModel.invoke(
                    location: location,
                    currentWeatherData: currentWeatherData,
                    dailyForecastData: dailyForecastData)
                
                if let currentWeather = try? self.jsonDecoder.decode(CurrentWeather.self, from: currentWeatherData),
                   let dailyForecast = try? self.jsonDecoder.decode(DailyForecast.self, from: dailyForecastData) {
                    handler(.success((currentWeather, dailyForecast)))
                } else {
                    handler(.failure(ApiError(statusCode: 101, statusMessage: "Error")))
                }
            })
    }
}
