//
//  GetLocationsInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

private var locations = [Location]()

class GetLocationsInteractor {
    init() {
        if locations.isEmpty {
            locations.append(
                Location(title: "Lutsk", lat: 50.7482711757513, lon: 25.329339998846542)
            )
        }
    }
    
    func invoke() -> [Location] {
        return locations
    }
}
