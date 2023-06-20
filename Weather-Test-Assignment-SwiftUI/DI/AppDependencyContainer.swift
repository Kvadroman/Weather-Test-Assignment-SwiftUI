//
//  AppDependencyContainer.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation
import Swinject

class AppDependencyContainer {
    private lazy var appDIContainer: Container = {
        Container { container in
            
            // MARK: - CL Manager
            container.register(CLManagerProtocol.self) { _ in
                CLManager()
            }.inObjectScope(.container)
            
            // MARK: - Network Repository
            container.register(NetworkRepositoryProtocol.self) { _ in
                NetworkRepository()
            }.inObjectScope(.container)
            
            // MARK: - Weather Repository
            container.register(WeatherRepositoryProtocol.self) { resolver in
                WeatherRepository(
                    clManager: resolver.resolve(CLManagerProtocol.self)!,
                    networkRepository: resolver.resolve(NetworkRepositoryProtocol.self)!
                )
            }.inObjectScope(.container)
            
            // MARK: - WeatherDate Processor
            container.register(WeatherDateProcessorProtocol.self) { _ in
                WeatherDateProcessor()
            }.inObjectScope(.container)
            
            // MARK: - AppViewModel
            container.register(AppViewModel.self) { resolver in
                AppViewModel()
            }.inObjectScope(.container)
            
            // MARK: - MainFlowDIC
            container.register(MainFlowCoordinatorsDIC.self) { _ in
                MainFlowCoordinatorsDIC(parentContainer: container)
            }
            
            // MARK: - AppView
            container.register(AppView.self) { (resolver, container: AppDependencyContainer) in
                AppView(viewModel: resolver.resolve(AppViewModel.self)!, container: container)
            }.inObjectScope(.container)
        }
    }()
    
    func resolveAppView(container: AppDependencyContainer) -> AppView {
        appDIContainer.resolve(AppView.self, argument: container)!
    }
    
    func resolverMainFlowDIC() -> MainFlowCoordinatorsDIC {
        appDIContainer.resolve(MainFlowCoordinatorsDIC.self)!
    }
}
