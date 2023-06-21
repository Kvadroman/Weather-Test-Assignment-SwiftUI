//
//  CurrentWeatherCell.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 21.06.2023.
//

import SwiftUI

struct CurrentWeatherCell: View {
    var forecast: ForeCastProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let forecast = forecast as? Forecast {
                Text("Date: \(Date(timeIntervalSince1970: TimeInterval(forecast.dt)).convertToHours())")
            } else {
                Text(forecast.date)
            }
            Text(forecast.temperatureCelsius)
            Text(forecast.minTemperatureCelsius)
            Text(forecast.maxTemperatureCelsius)
            Text(forecast.feelsLikeCelsius)
            Text(forecast.description)
            Text(forecast.pressure)
            Text(forecast.windSpeed)
            Text(forecast.humidity)
            Text(forecast.cloudsAll)
        }
        .padding()
    }
}
