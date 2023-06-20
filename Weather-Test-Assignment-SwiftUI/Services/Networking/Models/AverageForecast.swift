//
//  AverageForecast.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation

struct AverageForecast: Hashable, ForeCastProtocol {
    var dateObject: Date
    var date: String
    var temperatureCelsius: String
    var minTemperatureCelsius: String
    var maxTemperatureCelsius: String
    var feelsLikeCelsius: String
    var description: String
    var pressure: String
    var windSpeed: String
    var humidity: String
    var cloudsAll: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateObject)
    }
}
