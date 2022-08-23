//
//  RemoveLocationInteractor.swift
//  Weather
//
//  Created by Александр Шерий on 23.08.2022.
//

import Foundation
import RealmSwift

class RemoveLocationInteractor {
    func invoke(location: Location, handler: @escaping (Result<Void, Error>) -> Void) {
        let realm = try! Realm()
        realm.writeAsync {
            realm.delete(location)
        } onComplete: { error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(()))
            }
        }
    }
}
