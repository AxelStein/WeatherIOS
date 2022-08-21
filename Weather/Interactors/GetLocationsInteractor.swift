//
//  GetLocationsInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

class GetLocationsInteractor {
    private let dataSource = LocationDataSource()
    
    func invoke() -> [Location] {
        return dataSource.getLocations()
    }
}
