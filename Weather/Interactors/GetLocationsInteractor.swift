//
//  GetLocationsInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import Foundation
import RealmSwift

class GetLocationsInteractor {
    
    func invoke() -> [Location] {
        let realm = try! Realm()
        return realm.objects(Location.self).map { $0 }
    }
}
