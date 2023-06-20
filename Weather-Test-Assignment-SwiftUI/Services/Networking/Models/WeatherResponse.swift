//
//  WeatherResponse.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

struct WeatherResponseByCityName: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: SysForCityName
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct WeatherResponse: Codable, Equatable, Hashable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
    
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        lhs.cnt == rhs.cnt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
    }
}

struct City: Codable, Hashable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct Forecast: Codable, Equatable, Hashable, Identifiable {
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Sys: Codable {
    let pod: String
}

struct SysForCityName: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Rain: Codable {
    let h3: Double
    
    enum CodingKeys: String, CodingKey {
        case h3 = "3h"
    }
}

extension Forecast: ForeCastProtocol {
    var description: String {
        "Description: \(weather.first?.description.capitalized ?? "")"
    }
    
    var pressure: String {
        "Pressure \(main.pressure) hPa"
    }
    
    var windSpeed: String {
        "Wind Speed: \(wind.speed) mph"
    }
    
    var humidity: String {
        "Humidity: \(main.humidity) %"
    }
    
    var cloudsAll: String {
        "Clouds: \(clouds.all) %"
    }
    var date: String {
        return Date(timeIntervalSince1970: TimeInterval(dt)).convertToString()
    }
    
    var temperatureCelsius: String {
        main.temperatureCelsius
    }
    
    var minTemperatureCelsius: String {
        main.minTemperatureCelsius
    }
    
    var maxTemperatureCelsius: String {
        main.maxTemperatureCelsius
    }
    
    var feelsLikeCelsius: String {
        main.feelsLikeCelsius
    }
    
    var dateAsDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.date(from: date)
    }
}

extension Main {
    var feelsLikeCelsius: String {
        "Feels Like: \(Int(feelsLike - 273.15)) ℃"
    }
    
    var temperatureCelsius: String {
        "Temperature: \(Int(temp - 273.15)) ℃"
    }
    
    var minTemperatureCelsius: String {
        "Min Temperature: \(Int(tempMin - 273.15)) ℃"
        
    }
    
    var maxTemperatureCelsius: String {
        "Max Temperature: \(Int(tempMax - 273.15)) ℃"
    }
}

