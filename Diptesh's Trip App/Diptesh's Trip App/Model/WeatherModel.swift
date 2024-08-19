

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
    let main: String
}

struct Wind: Codable {
    let speed: Double
}

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let windSpeed: Double
    let humidity: Double
    let weather: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}
