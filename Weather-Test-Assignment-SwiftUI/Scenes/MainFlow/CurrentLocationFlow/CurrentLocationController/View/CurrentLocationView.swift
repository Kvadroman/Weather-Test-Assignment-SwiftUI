//
//  CurrentLocationView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine

struct CurrentLocationView<T: CurrentLocationViewModeling>: ContentView {
    typealias ViewModelType = T
    
    @ObservedObject var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(viewModel.output.averageForecasts.value ?? [], id: \.self) { averageForecast in
                NavigationLink(
                    destination: {
                        DetailsForecastView(forecasts: viewModel.output.hourlyForecast.value ?? [])
                            .onAppear {
                                viewModel.input.didTapOnSelectedDay.send(averageForecast.dateObject)
                            }
                    },
                    label: {
                        CurrentWeatherCell(forecast: averageForecast)
                    }
                )
            }
            .onAppear {
                viewModel.input.viewDidLoad.send()
            }
            .padding(EdgeInsets(top: 0, leading: -20, bottom: -20, trailing: -20))
            .navigationBarTitle(viewModel.output.weatherResponse.value?.city.name ?? "", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                viewModel.input.didTapUpdateWeather.send()
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
            })
        }
        .alert(isPresented: alertIsPresented) {
            alertContent()
        }
    }
    
    private var alertIsPresented: Binding<Bool> {
        Binding<Bool>.init(
            get: { viewModel.output.errorMessage.value != nil },
            set: { _ in }
        )
    }
    
    private func alertContent() -> Alert {
        Alert(title: Text("Error"),
              message: Text(viewModel.output.errorMessage.value?.localizedDescription ?? "Unknown error"),
              dismissButton: .default(Text("OK")) {
            viewModel.output.errorMessage.value = nil
        }
        )
    }
}
