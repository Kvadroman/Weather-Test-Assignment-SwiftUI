//
//  CurrentLocationViewModel.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

final class CurrentLocationViewModel: CurrentLocationViewModeling {
    
    struct Input: CurrentLocationViewModelingInput {
        var viewDidLoad: PassthroughSubject<Void, Never>
        var didTapUpdateWeather: PassthroughSubject<Void, Never>
        var didTapOnSelectedDay: PassthroughSubject<Date, Never>
    }
    
    struct Output: CurrentLocationViewModelingOutput {
        var selectedDay: CurrentValueSubject<Date?, Never>
        var weatherResponse: CurrentValueSubject<WeatherResponse?, Never>
        var averageForecasts: CurrentValueSubject<[AverageForecast]?, Never>
        var errorMessage: CurrentValueSubject<Error?, Never>
        var hourlyForecast: CurrentValueSubject<[Forecast]?, Never>
    }
    
    @Published var input: Input
    @Published var output: Output
    
    // Input
    private var viewDidLoad = PassthroughSubject<Void, Never>()
    private var didTapUpdateWeather = PassthroughSubject<Void, Never>()
    private var didTapOnSelectedDay = PassthroughSubject<Date, Never>()
    
    // Output
    private var selectedDay = CurrentValueSubject<Date?, Never>(nil)
    private var weatherResponse = CurrentValueSubject<WeatherResponse?, Never>(nil)
    private var averageForecasts = CurrentValueSubject<[AverageForecast]?, Never>([])
    private var errorMessage = CurrentValueSubject<Error?, Never>(nil)
    private var hourlyForecast = CurrentValueSubject<[Forecast]?, Never>([])
    
    private let weatherRepo: WeatherRepositoryProtocol
    private let weatherDateProcessor: WeatherDateProcessorProtocol
    private var didLoad: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.weatherDateProcessor = WeatherDateProcessor()
        self.weatherRepo = WeatherRepository(clManager: CLManager(),
                                             networkRepository: NetworkRepository())
        self.input = .init(viewDidLoad: viewDidLoad,
                           didTapUpdateWeather: didTapUpdateWeather,
                           didTapOnSelectedDay: didTapOnSelectedDay)
        self.output = .init(selectedDay: selectedDay,
                            weatherResponse: weatherResponse,
                            averageForecasts: averageForecasts,
                            errorMessage: errorMessage,
                            hourlyForecast: hourlyForecast)
        bind()
    }
    
    private func bind() {
        
        viewDidLoad
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let didLoad = self?.didLoad, !didLoad else { return }
                self?.getWeather()
                self?.didLoad.toggle()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        didTapUpdateWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.output.errorMessage.value = nil
                self?.getWeather()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        didTapOnSelectedDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedDate in
                self?.output.selectedDay.value = selectedDate
                self?.output.hourlyForecast.value = self?.output.weatherResponse.value?.list.filter { forecast in
                    guard let date = forecast.dateAsDate else { return false }
                    return date.isSameDay(as: selectedDate)
                }
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        weatherRepo.error
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.output.errorMessage.value = error
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

    }
    
    private func getWeather() {
        weatherRepo.fetchWeather { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.output.weatherResponse.value = weather
                    self?.output.averageForecasts.value = self?.weatherDateProcessor.processForecasts(weather.list) ?? []
                case .failure(let error):
                    self?.output.errorMessage.value = error
                }
                self?.objectWillChange.send()
            }
        }
    }
}
