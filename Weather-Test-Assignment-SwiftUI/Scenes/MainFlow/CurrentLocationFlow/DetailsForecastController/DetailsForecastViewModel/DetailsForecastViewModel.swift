//
//  DetailsLocationViewModel.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import Foundation

final class DetailsForecastViewModel: DetailsForecastViewModeling {
    
    struct Input: DetailsForecastViewModelingInput {
        var viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    class Output: DetailsForecastViewModelingOutput {
    }
    
    lazy var input: Input = Input(viewDidLoad: viewDidLoad)
    lazy var output: Output = Output()
    
    // Input
    private let viewDidLoad = PassthroughSubject<Void, Never>()
    
    @Published private var hourlyForecast: [Forecast]?
    private var cancellables: Set<AnyCancellable> = []
    
    init(hourlyForecast: [Forecast]?) {
        self._hourlyForecast = Published(initialValue: hourlyForecast)
        bind()
    }
    
    private func bind() {
        $hourlyForecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
