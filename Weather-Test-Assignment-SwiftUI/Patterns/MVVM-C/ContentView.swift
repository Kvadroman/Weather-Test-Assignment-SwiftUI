//
//  ContentView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

protocol ContentView: View {
    associatedtype ViewModelType: ViewModel
    init(viewModel: ViewModelType)
}
