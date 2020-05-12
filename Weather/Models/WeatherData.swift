import Foundation

struct WeatherData: Codable {
    let lat, lon: Double
    let current: WeatherDetails
    let hourly: [Hourly]
    let daily: [Daily]
}

struct WeatherDetails: Codable, Loopable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi: Double?
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct Weather: Codable {
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
    let rain: Double?
}

struct Temp: Codable {
    let min, max: Double
}

extension WeatherData {
    func getHourForecast() -> [Hourly] {
        let calendar = Calendar.current
        let nearestHour = Date().nearestHour()
        let dayAfter = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: nearestHour))!
        
        return self.hourly.filter {
            $0.dt >= Int(nearestHour.timeIntervalSince1970)
                && $0.dt < Int(dayAfter.timeIntervalSince1970) }
    }
    
    func getDailyDetails() -> [String : Any] {
        var details = self.current.allProperties()
        details.removeValue(forKey: "dt")
        details.removeValue(forKey: "weather")
        return details
    }
}
