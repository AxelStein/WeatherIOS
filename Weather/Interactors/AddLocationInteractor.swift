//
//  AddLocationInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import Foundation

class AddLocationInteractor {
    private let dataSource = LocationDataSource()
    
    func invoke(location: Location) {
        dataSource.add(location)
    }
}
