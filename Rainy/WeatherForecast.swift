//
//  WeatherForecast.swift
//  Rainy
//
//  Created by Yana Ivanova on 17.10.16.
//  Copyright © 2016 Yana Ivanova. All rights reserved.
//

import Foundation
import Alamofire


class WeatherForecast {
    
    var currentCityName: String
    var weatherDescription: String
    var weatherTemp: Double?
    var imageName: String
    var date:  Date
    var humidity: Double
    var windSpeed: Double
    var locationCoordinates: (Double, Double)    
    
    init() {
        currentCityName = ""
        weatherDescription = ""
        weatherTemp = 0
        imageName = ""
        date = Date()
        humidity = 0
        windSpeed = 0
        locationCoordinates = (0,0)
    }
    
}
