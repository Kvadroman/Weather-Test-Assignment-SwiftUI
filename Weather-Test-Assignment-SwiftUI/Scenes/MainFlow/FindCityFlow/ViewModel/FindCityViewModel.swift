//
//  FindCityViewModel.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

final class FindCityViewModel: FindCityViewModeling {
    
    struct Input: FindCityViewModelingInput {
        var didEnterCityName: PassthroughSubject<String, Never>
        var refreshError: PassthroughSubject<Void, Never>
    }
    
    struct Output: FindCityViewModelingOutput {
        var foreCastModel: CurrentValueSubject<WeatherResponseByCityName?, Never>
        var cityName: CurrentValueSubject<String?, Never>
        var onError: CurrentValueSubject<Error?, Never>
        
    }
    
    // Observable objects
    @Published var input: Input
    @Published var output: Output
    
    // Input
    private var didEnterCityName = PassthroughSubject<String, Never>()
    private var refreshError = PassthroughSubject<Void, Never>()
    
    // Output
    private var foreCastModel = CurrentValueSubject<WeatherResponseByCityName?, Never>(nil)
    private var cityName = CurrentValueSubject<String?, Never>("")
    private var onError = CurrentValueSubject<Error?, Never>(nil)
    
    private let weatherRepo: WeatherByCityRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.input = .init(didEnterCityName: didEnterCityName, refreshError: refreshError)
        self.output = .init(foreCastModel: foreCastModel, cityName: cityName, onError: onError)
        self.weatherRepo = WeatherRepository(clManager: CLManager(),
                                             networkRepository: NetworkRepository())
        bind()
    }
    
    private func bind() {
        didEnterCityName
            .drop(while: { $0 == "" })
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] cityName in
                self?.getWeather(by: cityName)
                self?.output.cityName.value = ""
            }
            .store(in: &cancellables)
        
        refreshError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.output.onError.value = nil
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func getWeather(by cityName: String) {
        weatherRepo.fetchWeatherByCityName(with: cityName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let foreCastModel):
                    self?.output.foreCastModel.value = foreCastModel
                case .failure(let error):
                    self?.output.onError.value = error
                }
                self?.objectWillChange.send()
            }
        }
    }
}
