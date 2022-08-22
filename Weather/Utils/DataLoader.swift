//
//  DataLoader.swift
//  Weather
//
//  Created by Александр Шерий on 17.08.2022.
//

import Foundation

class DataLoader {
    func request(endpoint: Endpoint, handler: @escaping (Result<Data, DataLoaderError>) -> Void) {
        guard let url = endpoint.url else { return handler(.failure(.invalidURL)) }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, res, err in
            if let data = data {
                handler(.success(data))
            } else {
                handler(.failure(.network(error: err)))
            }
        }
        task.resume()
    }
}

enum DataLoaderError: Error {
    case invalidURL
    case network(error: Error?)
}
