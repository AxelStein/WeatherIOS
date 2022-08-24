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
    func invoke(location: LocationModel) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext
        
        viewContext.delete(location)
        
        app.saveChanges()
    }
}
