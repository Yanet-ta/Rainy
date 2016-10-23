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
    var currentWeatherTemp: Double?
    var imageName: String
    var timestamp:  Double
    var humidity: Double
    var windSpeed: Double
    var locationCoordinates: (Double, Double)
    
    
    init() {
        currentCityName = ""
        weatherDescription = ""
        currentWeatherTemp = 0
        imageName = ""
        timestamp = 0
        humidity = 0
        windSpeed = 0
        locationCoordinates = (0,0)
    }
    
   /* init(currentCityName: String, weatherDescription: String, currentWeatherTemp: Double?, imageName: String, timestamp: Double, humidity: Double, windSpeed: Double, locationCoordinates: (Double, Double)) {
        self.currentCityName = currentCityName
        self.weatherDescription = weatherDescription
        self.currentWeatherTemp = currentWeatherTemp
        self.imageName = imageName
        self.timestamp = timestamp
        self.humidity = humidity
        self.windSpeed = windSpeed
         self.locationCoordinates = locationCoordinates
    } */
    

    
}
