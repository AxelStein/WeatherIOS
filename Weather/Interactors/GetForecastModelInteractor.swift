//
//  GetForecastModelInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 24.08.2022.
//

import UIKit
import CoreData

class GetForecastModelInteractor {
    private let jsonDecoder: JSONDecoder!
    private let app: AppDelegate!
    private let viewContext: NSManagedObjectContext!
    
    init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        app = UIApplication.shared.delegate as? AppDelegate
        viewContext = app.persistentContainer.viewContext
    }
    
    func invoke(at location: LocationModel) -> ForecastModel? {
        let request = NSFetchRequest<ForecastModel>(entityName: "ForecastModel")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "location = %@", location)
        
        return try? viewContext.fetch(request).first
    }
    
    func invoke(location: LocationModel) -> (CurrentWeather, DailyForecast)? {
        if let model = self.invoke(at: location) {
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
