//
//  Weather_Test_Assignment_SwiftUIApp.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

@main
struct Weather_Test_Assignment_SwiftUIApp: App {
    let container = AppDependencyContainer()
    var body: some Scene {
        WindowGroup {
            container.resolveAppView(container: container)
        }
    }
}
