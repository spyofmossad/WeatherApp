//
//  ImageManager.swift
//  Weather
//
//  Created by Dmitry on 11.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    func getImage(by id: String, completion: @escaping (Data) -> ()) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "openweathermap.org"
        urlComponents.path = "/img/wn/\(id)@2x.png"
        
        DispatchQueue.global().async {
            guard let url = urlComponents.url else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            completion(imageData)
        }
    }
}
