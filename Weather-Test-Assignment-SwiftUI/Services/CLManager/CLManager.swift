//
//  CLManager.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Combine
import CoreLocation
import Foundation

protocol CLManagerProtocol {
    var location: AnyPublisher<ForeCastModel?, Never> { get }
    var error: AnyPublisher<CLError?, Never> { get }
    func checkStatus()
}

final class CLManager: NSObject, CLManagerProtocol, CLLocationManagerDelegate {
    var location: AnyPublisher<ForeCastModel?, Never> {
        $currentLocation.eraseToAnyPublisher()
    }
    var error: AnyPublisher<CLError?, Never> {
        _error.eraseToAnyPublisher()
    }
    private var locationManager: CLLocationManager!
    private var _error = PassthroughSubject<CLError?, Never>()
    private var status: CLAuthorizationStatus?
    @Published private var currentLocation: ForeCastModel?
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        getLocation()
    }
    
    func checkStatus() {
        guard let status else {
            _error.send(CLError.emptyStatus)
            return
        }
        switch status {
        case .denied, .restricted:
            _error.send(CLError.deniedError)
        case .authorized, .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            break
        @unknown default:
            _error.send(CLError.unknownStatus)
        }
    }
    
    private func getLocation() {
        status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            _error.send(CLError.deniedError)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .none:
            _error.send(CLError.unknownStatus)
        @unknown default:
            _error.send(CLError.unknownStatus)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            _error.send(CLError.changeStatus)
            return
        }
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = ForeCastModel(lat: "\(location.coordinate.latitude)",
                                            lon: "\(location.coordinate.longitude)")
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _error.send(CLError.failedToFind)
    }
}
