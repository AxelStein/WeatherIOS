//
//  GetForecastInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 16.08.2022.
//

import Foundation
import UIKit
import CoreData

class GetDailyForecastInteractor {
    private let dataLoader = DataLoader()
    
    func invoke(location: LocationModel, handler: @escaping (Result<DailyForecast, Error>) -> Void) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<DailyForecastModel>(entityName: "DailyForecastModel")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "location = %@", location)
        
        if let model = try? viewContext.fetch(request).first {
            let minutesUntilNow = model.lastFetchTime?.minutesUntilNow ?? 0
            if minutesUntilNow < 30,
               let data = model.data,
               let forecast = self.parseDailyForecast(data) {
                print("### fetch from core data \(location.title ?? "")")
                handler(.success(forecast))
                return
            } else {
                viewContext.delete(model)
                app.saveChanges()
            }
        }
        
        dataLoader.request(endpoint: .getDailyForecast(location: location)) { result in
            print("### fetch from network \(location.title ?? "")")
            switch result {
            case .success(let data):
                if let forecast = self.parseDailyForecast(data) {
                    let model = DailyForecastModel(context: viewContext)
                    model.lastFetchTime = Date()
                    model.data = data
                    model.location = location
                    app.saveChanges()
                    
                    DispatchQueue.main.async {
                        handler(.success(forecast))
                    }
                } else if let apiError = self.parseApiError(data) {
                    DispatchQueue.main.async {
                        handler(.failure(apiError))
                    }
                } else {
                    DispatchQueue.main.async {
                        handler(.failure(ApiError(statusCode: 0, statusMessage: "Unknown error")))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            }
        }
    }
    
    private func parseDailyForecast(_ data: Data) -> DailyForecast? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(DailyForecast.self, from: data)
        } catch {}
        return nil
    }
    
    private func parseApiError(_ data: Data) -> ApiError? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ApiError.self, from: data)
        } catch {}
        return nil
    }
}
