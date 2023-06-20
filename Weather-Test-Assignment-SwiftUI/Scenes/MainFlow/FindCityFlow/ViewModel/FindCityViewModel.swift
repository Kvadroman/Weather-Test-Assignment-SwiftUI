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
    }
    
    class Output: FindCityViewModelingOutput {
    }
    
    lazy var input: Input = Input(didEnterCityName: didEnterCityName)
    lazy var output: Output = Output()
    
    // Input
    private let didEnterCityName = PassthroughSubject<String, Never>()
    
    private let weatherRepo: WeatherByCityRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(weatherRepo: WeatherByCityRepositoryProtocol) {
        self.weatherRepo = weatherRepo
        bind()
    }
    
    private func bind() {
        didEnterCityName
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .drop(while: { $0 == "" })
            .removeDuplicates()
            .sink { [weak self] cityName in
                self?.getWeather(by: cityName)
            }
            .store(in: &cancellables)
    }
    
    private func getWeather(by cityName: String) {
        weatherRepo.fetchWeatherByCityName(with: cityName) { [weak self] result in
            switch result {
            case .success(let foreCastModel):
                self?.output.foreCastModel = foreCastModel
            case .failure(let error):
                self?.output.onError = error
            }
        }
    }
}
