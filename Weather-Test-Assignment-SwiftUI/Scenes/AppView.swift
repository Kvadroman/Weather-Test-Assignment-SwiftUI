//
//  AppView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

struct AppView: View {
    
    var body: some View {
        TabView {
            CurrentLocationView(viewModel: CurrentLocationViewModel())
                .tabItem { Label("Current Location", systemImage: "location.circle") }
            
            FindCityView(viewModel: FindCityViewModel())
                .tabItem { Label("Find City", systemImage: "magnifyingglass.circle") }
        }
    }
}
