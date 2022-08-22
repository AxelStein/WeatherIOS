//
//  GetForecastInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 16.08.2022.
//

import Foundation

class GetDailyForecastInteractor {
    private let dataLoader = DataLoader()
    
    func invoke(location: Location, handler: @escaping (Result<DailyForecast, Error>) -> Void) {
        dataLoader.request(endpoint: .getDailyForecast(location: location)) { result in
            switch result {
            case .success(let data):
                if let forecast = self.parseDailyForecast(data) {
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
