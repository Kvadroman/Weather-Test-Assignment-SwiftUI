//
//  WeatherRepository.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import SwiftUI

protocol WeatherByCityRepositoryProtocol {
    var error: AnyPublisher<CLError?, Never> { get }
    func fetchWeatherByCityName(with cityName: String, completion: @escaping (Result<WeatherResponseByCityName, Error>) -> Void)
}

protocol WeatherRepositoryForecastProtocol {
    var error: AnyPublisher<CLError?, Never> { get }
    func fetchWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

protocol WeatherRepositoryProtocol: WeatherRepositoryForecastProtocol, WeatherByCityRepositoryProtocol{
    var error: AnyPublisher<CLError?, Never> { get }
    func fetchWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchWeatherByCityName(with cityName: String, completion: @escaping (Result<WeatherResponseByCityName, Error>) -> Void)
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private let clManager: CLManagerProtocol
    private let networkRepository: NetworkRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    var error: AnyPublisher<CLError?, Never> {
        clManager.error.eraseToAnyPublisher()
    }
    
    init(clManager: CLManagerProtocol, networkRepository: NetworkRepositoryProtocol) {
        self.clManager = clManager
        self.networkRepository = networkRepository
    }

    func fetchWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        clManager.checkStatus()
        clManager.location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.networkRepository.getWeatherForecast(with: location, completion: completion)
            }
            .store(in: &cancellables)
    }
    
    func fetchWeatherByCityName(with cityName: String, completion: @escaping (Result<WeatherResponseByCityName, Error>) -> Void) {
        networkRepository.getWeatherByCityName(city: cityName, completion: completion)
    }
}
