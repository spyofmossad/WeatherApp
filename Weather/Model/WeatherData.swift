import Foundation

struct WeatherData: Codable {
    let latitude, longitude: Double
    let currentWeather: WeatherDetails
    let hourlyWeather: [Hourly]
    let dailyWeather: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case currentWeather = "current"
        case hourlyWeather = "hourly"
        case dailyWeather = "daily"
    }
}

struct WeatherDetails: Codable, Loopable {
    let timestamp: Int
    let sunriseTime, sunsetTime: Int?
    let temperature, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let ultravioletIndex: Double?
    let clouds: Int
    let windSpeed: Double
    let windDegrees: Int
    let other: [Weather]

    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case ultravioletIndex = "uvi"
        case clouds
        case windSpeed = "wind_speed"
        case windDegrees = "wind_deg"
        case other = "weather"
    }
}

struct Weather: Codable {
    let mainDescription: String
    let detailDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case mainDescription = "main"
        case detailDescription = "description"
        case icon
    }
}

struct Hourly: Codable {
    let timestamp: Int
    let temperature: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temperature = "temp"
        case weather
    }
}

struct Daily: Codable {
    let timestamp: Int
    let temperature: Temp
    let weather: [Weather]
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temperature = "temp"
        case weather
        case rain
    }
}

struct Temp: Codable {
    let min, max: Double
}

extension WeatherData {
    func getHourForecast() -> [Hourly] {
        let calendar = Calendar.current
        let nearestHour = Date().nearestHour()
        let dayAfter = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: nearestHour))!
        
        return self.hourlyWeather.filter {
            $0.timestamp >= Int(nearestHour.timeIntervalSince1970)
                && $0.timestamp < Int(dayAfter.timeIntervalSince1970) }
    }
    
    func getDailyDetails() -> [String : Any] {
        var details = self.currentWeather.allProperties()
        details.removeValue(forKey: "dt")
        details.removeValue(forKey: "weather")
        return details
    }
}
