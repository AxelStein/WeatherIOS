//
//  AddLocationInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import Foundation
import CoreData
import UIKit

class AddLocationInteractor {
    
    func invoke(title: String, countryCode: String, lat: Double, lon: Double) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        let model = LocationModel(context: viewContext)
        model.title = title
        model.lat = lat
        model.lon = lon
        model.countryCode = countryCode
        model.position = -1
        
        app.saveChanges()
    }
}
