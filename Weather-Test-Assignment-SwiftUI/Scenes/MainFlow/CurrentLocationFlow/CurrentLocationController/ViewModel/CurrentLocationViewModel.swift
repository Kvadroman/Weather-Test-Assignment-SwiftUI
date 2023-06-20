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
    
    class Output: CurrentLocationViewModelingOutput {
        @Published var selectedDay: Date?
        @Published var weatherResponse: WeatherResponse?
        @Published var errorMessage: Error?
        @Published var hourlyForecast: [Forecast]?
    }
    
    var input: Input
    @Published var output: Output = Output()
    
    // Input
    private let viewDidLoad = PassthroughSubject<Void, Never>()
    private let didTapUpdateWeather = PassthroughSubject<Void, Never>()
    private let didTapOnSelectedDay = PassthroughSubject<Date, Never>()
    
    private let weatherRepo: WeatherRepositoryProtocol
    private var didLoad: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(weatherRepo: WeatherRepositoryProtocol) {
        self.weatherRepo = weatherRepo
        self.input = Input(viewDidLoad: viewDidLoad,
                           didTapUpdateWeather: didTapUpdateWeather,
                           didTapOnSelectedDay: didTapOnSelectedDay)
        bind()
    }
    
    private func bind() {
        output.$weatherResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        output.$selectedDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        output.$hourlyForecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        viewDidLoad
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let didLoad = self?.didLoad, !didLoad else { return }
                self?.getWeather()
                self?.didLoad.toggle()
            }
            .store(in: &cancellables)
        
        didTapUpdateWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.getWeather()
            }
            .store(in: &cancellables)
        
        didTapOnSelectedDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedDate in
                self?.output.selectedDay = selectedDate
                self?.output.hourlyForecast = self?.output.weatherResponse?.list.filter { forecast in
                    guard let date = forecast.dateAsDate else { return false }
                    return date.isSameDay(as: selectedDate)
                }
            }
            .store(in: &cancellables)
        
        weatherRepo.error
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.output.errorMessage = error
            }
            .store(in: &cancellables)

    }
    
    private func getWeather() {
        weatherRepo.fetchWeather { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self?.output.weatherResponse = weather
                    print(self?.output.weatherResponse?.list, "🥶🥶🥶")
                }
            case .failure(let error):
                self?.output.errorMessage = error
            }
        }
    }
}
