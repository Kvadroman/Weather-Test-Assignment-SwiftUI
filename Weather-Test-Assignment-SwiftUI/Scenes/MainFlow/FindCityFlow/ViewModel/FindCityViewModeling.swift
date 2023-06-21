//
//  FindCityViewModeling.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine

protocol FindCityViewModeling: ViewModel where Input: FindCityViewModelingInput, Output: FindCityViewModelingOutput {
}

protocol FindCityViewModelingInput {
    var didEnterCityName: PassthroughSubject<String, Never> { get }
    var refreshError: PassthroughSubject<Void, Never> { get }
}

protocol FindCityViewModelingOutput {
    var foreCastModel: CurrentValueSubject<WeatherResponseByCityName?, Never> { get }
    var cityName: CurrentValueSubject<String?, Never> { get }
    var onError: CurrentValueSubject<Error?, Never> { get }
}
