//
//  RemoveLocationInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 23.08.2022.
//

import Foundation
import UIKit
import CoreData

class RemoveLocationInteractor {
    private let getForecastModel = GetForecastModelInteractor()
    
    func invoke(location: LocationModel) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        viewContext.delete(location)
        
        if let model = getForecastModel.invoke(at: location) {
            viewContext.delete(model)
        }
        
        app.saveChanges()
    }
}
