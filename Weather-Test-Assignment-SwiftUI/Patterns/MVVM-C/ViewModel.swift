//
//  ViewModel.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import SwiftUI

protocol ViewModel: ObservableObject {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}
