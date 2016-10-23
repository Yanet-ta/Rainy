//
//  NetworkCore.swift
//  Rainy
//
//  Created by Yana Ivanova on 23.10.16.
//  Copyright © 2016 Yana Ivanova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkCoreError : Error {
    case ParseError(String)
    case NetwotkError(Error)
}

class NetworkCore {
    
    let apiKey = Constants.apiKey
    let urlString = "http://api.openweathermap.org/data/2.5/weather"
    
    static let sharedInstance = NetworkCore()
    private init() {}
    
     //получить погоду по имени города
    func requestForecastByCityName(cityName: String, completion : @escaping (WeatherForecast?, NetworkCoreError?) -> Void) {
        Alamofire.request(urlString, parameters: ["q": cityName, "APPID": apiKey, "units": "metric"]).responseJSON() {
            response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                if let tForecast  = self.parseResponse(json: json) {
                    completion(tForecast, nil)
                } else {
                    completion(nil, NetworkCoreError.ParseError("Can not parse"))
                }
            case.failure(let error):
                completion(nil, NetworkCoreError.NetwotkError(error))
            }
            
        }
    }
    
    /*
    //получить погоду по координатам: долготе и широте
    func requestForecastByLocation(latitude: Double, longitude: Double) {
        Alamofire.request(urlString, parameters: ["lat":latitude, "lon": longitude, "APPID": apiKey, "units": "metric"]).responseJSON() {
            response in
            switch response.result {
            case.success(let value):
                    let json = JSON(value)
                    self.parseResponse(json: json)
            case.failure(let error):
                print(error)
            }
        }
    } */
    
    private func parseResponse(json: JSON) -> WeatherForecast? {
        if json.type == .dictionary {
            let forecast = WeatherForecast()
            forecast.currentCityName = json["name"].stringValue
            forecast.timestamp = json["dt"].doubleValue
            if json["weather"][0].type == .dictionary {
                let weather = json["weather"][0]
                forecast.weatherDescription = weather["description"].stringValue
                forecast.imageName = weather["icon"].stringValue
            }
            if json["main"].type == .dictionary {
                let main = json["main"]
                forecast.currentWeatherTemp = main["temp"].doubleValue
                forecast.humidity = main["humidity"].doubleValue
            }
            if json["wind"].type == .dictionary {
                let wind = json["wind"]
                forecast.windSpeed = wind["speed"].doubleValue
            }
            return forecast
        }
        print(json)
        return nil
    }
    
    
}
