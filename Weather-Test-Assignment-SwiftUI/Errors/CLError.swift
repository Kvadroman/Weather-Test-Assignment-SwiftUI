//
//  CLError.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation

struct CLError: LocalizedError {
    var errorDescription: String? { message }
    private var message: String?
    
    init(_ message: String) {
        self.message = message
    }
    
    static let deniedError = CLError("Location services were previously denied. Please enable location services for this app in Settings.")
    static let changeStatus = CLError("In order to get current weather in your location, you need to turn on it in your settings")
    static let unknownStatus = CLError("A new authorization state was added that we did not handle")
    static let failedToFind = CLError("Failed to find user's location")
    static let emptyStatus = CLError("You need to reload the app")
}
