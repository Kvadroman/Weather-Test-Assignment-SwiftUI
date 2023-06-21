//
//  CurrentLocationViewModeling.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

protocol CurrentLocationViewModeling: ViewModel where Input: CurrentLocationViewModelingInput, Output: CurrentLocationViewModelingOutput {
}

protocol CurrentLocationViewModelingInput {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var didTapUpdateWeather: PassthroughSubject<Void, Never> { get }
    var didTapOnSelectedDay: PassthroughSubject<Date, Never> { get }
}

protocol CurrentLocationViewModelingOutput {
    var selectedDay: CurrentValueSubject<Date?, Never> { get }
    var weatherResponse: CurrentValueSubject<WeatherResponse?, Never> { get }
    var averageForecasts: CurrentValueSubject<[AverageForecast]?, Never> { get }
    var errorMessage: CurrentValueSubject<Error?, Never> { get }
    var hourlyForecast: CurrentValueSubject<[Forecast]?, Never> { get }
}
