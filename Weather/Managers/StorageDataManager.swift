//
//  StorageDataManager.swift
//  Weather
//
//  Created by Dmitry on 10.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

class StorageDataManager {
    
    static func saveWeatherData(weather: WeatherData) {
        do {
            let weatherJson = try JSONEncoder().encode(weather)
            UserDefaults.standard.set(weatherJson, forKey: "weatherJson")
        } catch let jsonError {
            print(jsonError.localizedDescription)
        }
    }
    
    static func getWeatherData() -> WeatherData? {
        if let weather = UserDefaults.standard.value(forKey: "weatherJson") {
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: weather as! Data)
                return weatherData
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }
        return nil
    }
    
    static func getData(by key: String) -> Data? {
        if let data = UserDefaults.standard.value(forKey: key) {
            return data as? Data
        }
        return nil
    }
    
    static func saveData(data: Data, with key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
}
