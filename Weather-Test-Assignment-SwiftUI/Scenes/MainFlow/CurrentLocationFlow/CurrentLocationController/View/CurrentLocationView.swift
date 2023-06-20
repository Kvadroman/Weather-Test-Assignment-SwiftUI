//
//  CurrentLocationView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine

struct CurrentLocationView<T: CurrentLocationViewModeling>: View, ContentView {
    @ObservedObject private var viewModel: T
    var weatherDateProcessor: WeatherDateProcessorProtocol?
    var detailsView: (([Forecast]?) -> DetailsForecastView<DetailsForecastViewModel>)?
    
    // MARK: - Init
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach((weatherDateProcessor?.processForecasts(viewModel.output.weatherResponse?.list ?? []) ?? []) as [AverageForecast], id: \.date) { forecast in
                    let detailsView = detailsView?(viewModel.output.hourlyForecast)
                    NavigationLink(destination:  detailsView,
                                   isActive: Binding(
                                    get: { viewModel.output.selectedDay == forecast.dateObject },
                                    set: { _ in }
                                   )) {
                                       CurrentWeatherRow(forecast: forecast)
                                   }
                                   .onTapGesture {
                                       viewModel.input.didTapOnSelectedDay.send(forecast.dateObject)
                                   }
                }
            }
            .padding(EdgeInsets(top: 0, leading: -20, bottom: -20, trailing: -20))
            .navigationBarTitle(viewModel.output.weatherResponse?.city.name ?? "")
            .navigationBarItems(trailing:
                                    Button(action: {
                viewModel.input.didTapUpdateWeather.send()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
            }
            )
            .alert(isPresented: Binding<Bool>.init(
                get: { self.viewModel.output.errorMessage != nil },
                set: { _ in }
            ), content: { () -> Alert in
                Alert(title: Text("Error"), message: Text(self.viewModel.output.errorMessage?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")))
            })
        }
        .onAppear {
            viewModel.input.viewDidLoad.send()
        }
    }
}

struct CurrentWeatherRow: View {
    var forecast: ForeCastProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(forecast.date)
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
