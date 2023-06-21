//
//  WeatgerDateProcessor.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation

protocol WeatherDateProcessorProtocol {
    func processForecasts(_ forecasts: [Forecast]) -> [AverageForecast]
}

final class WeatherDateProcessor: WeatherDateProcessorProtocol {
    private let calendar = Calendar.current

    func processForecasts(_ forecasts: [Forecast]) -> [AverageForecast] {
        let groupedForecasts = groupForecastsByDay(forecasts)
        return calculateAverages(groupedForecasts)
    }

    private func groupForecastsByDay(_ forecasts: [Forecast]) -> [Date: [Forecast]] {
        return Dictionary(grouping: forecasts) { forecast in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            return calendar.startOfDay(for: date)
        }
    }

    private func calculateAverages(_ groupedForecasts: [Date: [Forecast]]) -> [AverageForecast] {
        var averagedForecasts: [AverageForecast] = []

        for (date, forecasts) in groupedForecasts {
            let averageTemp = forecasts.map { $0.main.temp }.reduce(0, +) / Double(forecasts.count)
            let minTemp = forecasts.map { $0.main.tempMin }.min() ?? 0
            let maxTemp = forecasts.map { $0.main.tempMax }.max() ?? 0
            let averageFeelsLike = forecasts.map { $0.main.feelsLike }.reduce(0, +) / Double(forecasts.count)
            let averagePressure = forecasts.map { $0.main.pressure }.reduce(0, +) / forecasts.count
            let averageWindSpeed = forecasts.map { $0.wind.speed }.reduce(0, +) / Double(forecasts.count)
            let averageHumidity = forecasts.map { $0.main.humidity }.reduce(0, +) / forecasts.count
            let averageClouds = forecasts.map { $0.clouds.all }.reduce(0, +) / forecasts.count
            let weatherDescription = forecasts.first?.weather.first?.description ?? ""

            // Construct a new AverageForecast instance from the averaged values
            let averagedForecast = AverageForecast(
                dateObject: date,
                date: "Date: \(date.convertToString())",
                temperatureCelsius: "Average Temperature: \(Int(averageTemp - 273.15)) ℃",
                minTemperatureCelsius: "Min Temperature: \(Int(minTemp - 273.15)) ℃",
                maxTemperatureCelsius: "Max Temperature: \(Int(maxTemp - 273.15)) ℃",
                feelsLikeCelsius: "Feels Like: \(Int(averageFeelsLike - 273.15)) ℃",
                description: "Description: \(weatherDescription)",
                pressure: "Average Pressure: \(averagePressure) hPa",
                windSpeed: "Average Wind Speed: \(String(format: "%.2f", averageWindSpeed)) mph",
                humidity: "Average Humidity: \(averageHumidity) %",
                cloudsAll: "Average Clouds: \(averageClouds) %"
            )

            averagedForecasts.append(averagedForecast)
        }

        // sort by date
        return averagedForecasts.sorted { ($0.dateObject as Date) < ($1.dateObject as Date) }
    }
}

