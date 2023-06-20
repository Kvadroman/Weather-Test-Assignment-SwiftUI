//
//  DetailsLocationViewModeling.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

protocol DetailsForecastViewModeling: ViewModel where Input: DetailsForecastViewModelingInput, Output: DetailsForecastViewModelingOutput {
}

protocol DetailsForecastViewModelingInput {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

class DetailsForecastViewModelingOutput {
    @Published var hourlyForecastModel: [Forecast]?
}

