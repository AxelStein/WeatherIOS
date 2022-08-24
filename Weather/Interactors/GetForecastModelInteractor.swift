//
//  GetForecastModelInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 24.08.2022.
//

import UIKit
import CoreData

class GetForecastModelInteractor {
    func invoke(location: LocationModel) -> (CurrentWeather, DailyForecast)? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<ForecastModel>(entityName: "ForecastModel")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "location = %@", location)
        
        if let model = try? viewContext.fetch(request).first {
            let minutesUntilNow = model.lastFetchTime?.minutesUntilNow ?? 0
            if minutesUntilNow < 30 {
                let currentWeather = try! jsonDecoder.decode(CurrentWeather.self, from: model.currentWeatherData!)
                let dailyForecast = try! jsonDecoder.decode(DailyForecast.self, from: model.dailyForecastData!)
                return (currentWeather, dailyForecast)
            } else {
                viewContext.delete(model)
                app.saveChanges()
            }
        }
        
        return nil
    }
}
