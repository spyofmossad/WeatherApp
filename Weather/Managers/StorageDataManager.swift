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
            let weatherData = try JSONEncoder().encode(weather)
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            if let documentDirectory = documentDirectory {
                let path = documentDirectory.appendingPathComponent("weatherData")
                try weatherData.write(to: path)
            }
                        
        } catch let dataError {
            print(dataError.localizedDescription)
        }
    }
    
    static func getWeatherData() -> WeatherData? {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = documentDirectory.appendingPathComponent("weatherData")
            do {
                let data = try Data(contentsOf: url)
                let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                return weather
            } catch let error {
                print(error.localizedDescription)
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
