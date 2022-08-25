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

        let request = NSFetchRequest<LocationModel>(entityName: "LocationModel")
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        return try? viewContext.fetch(request).sorted { a, b -> Bool in
            switch (a.position == -1, b.position == -1) {
            case (true, true):
                return a.title ?? "" < b.title ?? ""
            case (false, true):
                return true
            case (true, false):
                return false
            default:
                return a.position < b.position
            }
        }
    }
}
