//
//  AddLocationInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import Foundation
import RealmSwift

class AddLocationInteractor {
    
    func invoke(location: Location, handler: @escaping (Result<Void, Error>) -> Void) {
        let realm = try! Realm()
        realm.writeAsync {
            realm.add(location)
        } onComplete: { error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(()))
            }
        }
    }
}
