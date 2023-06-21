//
//  DetailsLocationView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI
import Combine


struct DetailsForecastView: View {
    var forecasts: [Forecast]?
    
    var body: some View {
        List(forecasts ?? []) { forecast in
            CurrentWeatherCell(forecast: forecast)
        }
        .padding(EdgeInsets(top: 0, leading: -20, bottom: -20, trailing: -20))
        .onDisappear {
        }
    }
}
