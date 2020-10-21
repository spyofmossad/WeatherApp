//
//  NetworkingManager.swift
//  WeatherApp
//
//  Created by Dmitry on 05.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkManager {
    
    static func fetchData(for location: CLLocation, completion: @escaping (WeatherData) -> ()) {
                        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/onecall"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: "9549c560f4513bc71baa58ed687b10aa")
        ]
        
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error { print(error.localizedDescription) }
            guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
            }).resume()
    }
}
