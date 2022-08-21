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
            locations.append(
                Location(title: "Kiev", lat: 50.450343214352266, lon: 30.487354881962464)
            )
            locations.append(
                Location(title: "Kramatorsk", lat: 48.724868311124304, lon: 37.58747424803999)
            )
            locations.append(
                Location(title: "Trondheim", lat: 63.42444727686416, lon: 10.425296929932376)
            )
            locations.append(
                Location(title: "Ushu", lat: -54.817851, lon: -68.337654)
            )
        }
    }
    
    func invoke() -> [Location] {
        return locations
    }
}
