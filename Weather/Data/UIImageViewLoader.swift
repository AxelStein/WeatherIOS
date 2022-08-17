//
//  Ext.swift
//  Weather
//
//  Created by Александр Шерий on 17.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func load(src: String) {
        guard let url = URL(string: src) else { return }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { data, res, err in
            guard let data = data, err == nil else {
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
