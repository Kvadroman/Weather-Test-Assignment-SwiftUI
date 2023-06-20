//
//  FindCityView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine

struct FindCityView<T: FindCityViewModeling>: View, ContentView {
    
    @ObservedObject var viewModel: T
    
    @State var cityName: String = ""
    
    // MARK: - Init
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search City", text: $cityName, onEditingChanged: { finished in
                if finished {
                    viewModel.input.didEnterCityName.send(cityName)
                    cityName = ""
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
        VStack(alignment: .leading) {
            Text("City: \(viewModel.output.foreCastModel?.name ?? "Unknown")")
            Text("Temperature: \(viewModel.output.foreCastModel?.main.temperatureCelsius ?? "Unknown")")
            Text("Minimum Temperature: \(viewModel.output.foreCastModel?.main.minTemperatureCelsius ?? "Unknown")")
            Text("Maximum Temperature: \(viewModel.output.foreCastModel?.main.maxTemperatureCelsius ?? "Unknown")")
            Text("Feels Like: \(viewModel.output.foreCastModel?.main.feelsLikeCelsius ?? "Unknown")")
            Text("Pressure: \(viewModel.output.foreCastModel?.main.pressure ?? 0) hPa")
            Text("Wind Speed: \(viewModel.output.foreCastModel?.wind.speed ?? 0) mph")
            Text("Humidity: \(viewModel.output.foreCastModel?.main.humidity ?? 0) %")
            Text("Clouds: \(viewModel.output.foreCastModel?.clouds.all ?? 0) %")
            Text("Description: \(viewModel.output.foreCastModel?.weather.first?.description ?? "Unknown")")
        }
        .alert(isPresented: .constant(self.viewModel.output.onError != nil)) {
            Alert(title: Text("Error"), message: Text(self.viewModel.output.onError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK"), action: {
                self.viewModel.output.onError = nil  // Reset the error after it has been shown
            }))
        }
    }
}
