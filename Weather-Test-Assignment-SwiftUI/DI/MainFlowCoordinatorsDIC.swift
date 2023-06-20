//
//  MainFlowCoordinatorsDIC.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Swinject

class MainFlowCoordinatorsDIC {
    private let container: Container
    init(parentContainer: Container) {
        container = Container(parent: parentContainer) { container in
            // View Models
            container.register(CurrentLocationViewModel.self) { resolver in
                CurrentLocationViewModel(weatherRepo: resolver.resolve(WeatherRepositoryProtocol.self)!)
            }
            container.register(DetailsForecastViewModel.self) { (_, forecasts: [Forecast]?) in
                DetailsForecastViewModel(hourlyForecast: forecasts)
            }
            container.register(FindCityViewModel.self) { resolver in
                FindCityViewModel(weatherRepo: resolver.resolve(WeatherRepositoryProtocol.self)!)
            }
            
            // Views
            container.register(CurrentLocationView<CurrentLocationViewModel>.self) { resolver in
                var controller = CurrentLocationView(viewModel: resolver.resolve(CurrentLocationViewModel.self)!)
                controller.weatherDateProcessor = resolver.resolve(WeatherDateProcessorProtocol.self)!
                controller.detailsView = { forecasts in
                        resolver.resolve(DetailsForecastView<DetailsForecastViewModel>.self, argument: forecasts)!
                    }
                return controller
            }
            container.register(DetailsForecastView<DetailsForecastViewModel>.self) { (resolver, forecasts: [Forecast]?) in
                DetailsForecastView(viewModel: resolver.resolve(DetailsForecastViewModel.self, argument: forecasts)!)
            }
            container.register(FindCityView<FindCityViewModel>.self) { resolver in
                FindCityView(viewModel: resolver.resolve(FindCityViewModel.self)!)
            }
        }
    }
    
    func resolveCurrentLocationView() -> CurrentLocationView<CurrentLocationViewModel> { container.resolve(CurrentLocationView<CurrentLocationViewModel>.self)! }
    func resolveDetailsForecastView(with forecasts: [Forecast]?) -> DetailsForecastView<DetailsForecastViewModel> {
        container.resolve(DetailsForecastView<DetailsForecastViewModel>.self, argument: forecasts)! }
    func resolveFindCityView() -> FindCityView<FindCityViewModel> {
        container.resolve(FindCityView<FindCityViewModel>.self)! }
}
