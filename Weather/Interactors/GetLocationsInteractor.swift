//
//  GetLocationsInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation

import CoreData
import UIKit

class GetLocationsInteractor {
    
    func invoke() -> [LocationModel]? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let viewContext = app.persistentContainer.viewContext

        let objectModel = viewContext.persistentStoreCoordinator?.managedObjectModel
        guard let fetchRequest = objectModel?.fetchRequestTemplate(forName: "fetchAllLocations") as? NSFetchRequest<LocationModel> else { return nil }
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result
        } catch {
            print(error)
        }
        
        return nil
    }
}
