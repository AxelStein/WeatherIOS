//
//  SaveForecastModel.swift
//  Weather
//
//  Created by Александр Шерий on 24.08.2022.
//

import UIKit

class SaveForecastModelInteractor {
    
    func invoke(location: LocationModel, currentWeatherData: Data, dailyForecastData: Data) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        let model = ForecastModel(context: viewContext)
        model.currentWeatherData = currentWeatherData
        model.dailyForecastData = dailyForecastData
        model.location = location
        model.lastFetchTime = Date()
        app.saveChanges()
    }
}
