//
//  File.swift
//  Weather
//
//  Created by Александр Шерий on 15.08.2022.
//

import Foundation
import RealmSwift

class Location: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var title: String
    @Persisted var lat: Double
    @Persisted var lon: Double
    
    convenience init(title: String, lat: Double, lon: Double) {
        self.init()
        self.title = title
        self.lat = lat
        self.lon = lon
    }
}
