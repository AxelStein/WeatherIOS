//
//  Ext.swift
//  Weather
//
//  Created by Александр Шерий on 17.08.2022.
//

import Foundation
import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()
private let loadQueue = DispatchQueue(label: "img-load-queue")

extension UIImageView {
    
    func load(src: String) {
        guard let url = URL(string: src) else { return }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard let data = data, err == nil else {
                return
            }
            if let img = UIImage(data: data) {
                imageCache.setObject(img, forKey: url as AnyObject)
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }
        task.resume()
    }
}
