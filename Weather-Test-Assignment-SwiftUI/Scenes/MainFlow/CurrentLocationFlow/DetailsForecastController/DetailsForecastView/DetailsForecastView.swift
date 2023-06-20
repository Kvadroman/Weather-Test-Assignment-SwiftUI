//
//  DetailsLocationView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine


struct DetailsForecastView<T: DetailsForecastViewModeling>: View, ContentView {
    @ObservedObject var viewModel: T
    
    // MARK: - Init
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.output.hourlyForecastModel ?? []) { forecast in
            CurrentWeatherCell(forecast: forecast)
        }
        .onAppear(perform: {
            self.viewModel.input.viewDidLoad.send()
        })
    }
}

struct CurrentWeatherCell: View {
    var forecast: ForeCastProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Date: \(forecast.date)")
            Text("Temperature: \(forecast.temperatureCelsius)")
            Text("Min Temperature: \(forecast.minTemperatureCelsius)")
            Text("Max Temperature: \(forecast.maxTemperatureCelsius)")
            Text("Feels Like: \(forecast.feelsLikeCelsius)")
            Text("Description: \(forecast.description)")
            Text("Pressure: \(forecast.pressure)")
            Text("Wind Speed: \(forecast.windSpeed)")
            Text("Humidity: \(forecast.humidity)")
            Text("Clouds: \(forecast.cloudsAll)")
        }
        .padding()
    }
}
