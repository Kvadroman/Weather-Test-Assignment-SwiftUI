//
//  FindCityView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine

struct FindCityView<T: FindCityViewModeling>: ContentView {
    typealias ViewModelType = T
    
    @ObservedObject var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            let cityNameBinding = Binding<String>(
                get: { viewModel.output.cityName.value ?? "" },
                set: { newValue in viewModel.output.cityName.value = newValue }
            )
            
            TextField("Search City", text: cityNameBinding, onCommit: {
                viewModel.input.didEnterCityName.send(viewModel.output.cityName.value ?? "")
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(viewModel.output.foreCastModel.value?.cityName ?? "")
                Text(viewModel.output.foreCastModel.value?.main.temperatureCelsius ?? "")
                Text(viewModel.output.foreCastModel.value?.main.minTemperatureCelsius ?? "")
                Text(viewModel.output.foreCastModel.value?.main.maxTemperatureCelsius ?? "")
                Text(viewModel.output.foreCastModel.value?.main.feelsLikeCelsius ?? "")
                Text(viewModel.output.foreCastModel.value?.pressureString ?? "")
                Text(viewModel.output.foreCastModel.value?.windSpeedString ?? "")
                Text(viewModel.output.foreCastModel.value?.humidityString ?? "")
                Text(viewModel.output.foreCastModel.value?.cloudsString ?? "")
                Text(viewModel.output.foreCastModel.value?.descriptionSting ?? "")
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: .constant(viewModel.output.onError.value != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.output.onError.value?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK"), action: {
                viewModel.input.refreshError.send()  // Reset the error after it has been shown
            }))
        }
    }
}
