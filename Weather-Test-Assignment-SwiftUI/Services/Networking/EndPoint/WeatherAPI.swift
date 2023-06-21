//
//  WeatherAPI.swift
//  Weather-Test-Assignment-SwiftUI
//
//  Created by Ивченко Антон on 16.06.2023.
//

import Foundation

enum WeatherAPI {
    case getWeather(model: ForeCastModel)
    case getWeatherByCityName(city: String)
}

extension WeatherAPI: EndPointType {
    var baseURL: String {
        return NetworkConstant.baseUrl
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/forecast"
        case .getWeatherByCityName:
            return "/data/2.5/weather"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getWeather(let model):
            return ["lat": model.lat,
                    "lon": model.lon,
                    "appid": NetworkConstant.openWeatherAPIKey,
            ]
        case .getWeatherByCityName(let city):
            return ["q": city,
                    "appid": NetworkConstant.openWeatherAPIKey,
            ]
        }
    }
}
