//
//  LocationDataSource.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import Foundation

private var locations = [Location]()

class LocationDataSource {
    
    func getLocations() -> [Location] {
        return locations
    }
    
    func add(_ location: Location) {
        locations.append(location)
    }
}
