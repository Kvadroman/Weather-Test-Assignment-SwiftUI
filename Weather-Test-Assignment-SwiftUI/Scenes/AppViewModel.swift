//
//  AppViewModel.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation
import Combine

enum DeepLink {
    case main
}

protocol AppViewModeling {
    var link: DeepLink? { get }
}

class AppViewModel: AppViewModeling, ObservableObject {
    @Published var link: DeepLink?

    init() {}

    func goToMainFlow() {
        link = .main
    }
}
