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
}

class FindCityViewModelingOutput {
    @Published var foreCastModel: WeatherResponseByCityName?
    @Published var onError: Error?
}
