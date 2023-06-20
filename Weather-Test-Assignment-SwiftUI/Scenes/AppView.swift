//
//  AppView.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    private var container: AppDependencyContainer
    
    init(viewModel: AppViewModel, container: AppDependencyContainer) {
        self.viewModel = viewModel
        self.container = container
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            if viewModel.link == .main {
                TabView {
                    container.resolverMainFlowDIC().resolveCurrentLocationView()
                        .tabItem {
                            Image(systemName: "location.circle")
                            Text("Current Location")
                        }
                    container.resolverMainFlowDIC().resolveFindCityView()
                        .tabItem {
                            Image(systemName: "magnifyingglass.circle")
                            Text("Find City")
                        }
                }
            } else {
                // TODO: You need to implement your own logic
                EmptyView()
            }
        }.onAppear(perform: {
            viewModel.goToMainFlow()
        })
    }
}
