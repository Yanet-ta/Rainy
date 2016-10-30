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
    let urlString = Constants.urlString
    let urlForecastString = Constants.urlForecastString
    
    static let sharedInstance = NetworkCore()
    private init() {}
    
    //получить погоду по имени города
    func requestDailyForecastByCityName(cityName: String, completion : @escaping (Array<WeatherForecast>?, NetworkCoreError?) -> Void) {
        Alamofire.request(urlForecastString, parameters: ["q": cityName, "APPID": apiKey, "units": "metric", "cnt": Constants.defaultMaxDayCount]).responseJSON() {
            response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                if let tForecasts  = self.parseResponseForDailyForecast(json: json) {
                    completion(tForecasts, nil)
                } else {
                    completion(nil, NetworkCoreError.ParseError("Can not parse"))
                }
            case.failure(let error):
                completion(nil, NetworkCoreError.NetwotkError(error))
            }
            
        }
    }
    
    
    //получить погоду по координатам: долготе и широте
    func requestForecastByLocation(latitude: Double, longitude: Double, completion : @escaping (WeatherForecast?, NetworkCoreError?) -> Void) {
        Alamofire.request(urlString, parameters: ["lat":latitude, "lon": longitude, "APPID": apiKey, "units": "metric"]).responseJSON() {
            response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                if let tForecast  = self.parseResponseForCurrentDay(json: json) {
                    completion(tForecast, nil)
                } else {
                    completion(nil, NetworkCoreError.ParseError("Can not parse"))
                }
            case.failure(let error):
                completion(nil, NetworkCoreError.NetwotkError(error))
            }
            
        }
    }
    
    private func parseResponseForCurrentDay(json: JSON) -> WeatherForecast? {
        if json.type == .dictionary {
            let forecast = WeatherForecast()
            forecast.currentCityName = json["name"].stringValue
            forecast.date = Date(timeIntervalSince1970: json["dt"].doubleValue)
            if json["weather"][0].type == .dictionary {
                let weather = json["weather"][0]
                forecast.weatherDescription = weather["description"].stringValue
                forecast.imageName = weather["icon"].stringValue
            }
            if json["main"].type == .dictionary {
                let main = json["main"]
                forecast.weatherTemp = main["temp"].doubleValue
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
    
    private func parseResponseForDailyForecast(json: JSON) -> Array<WeatherForecast>? {
        if json.type == .dictionary {
            if json["list"].type == .array {
                let forecastList = json["list"]
                var forecasts = Array<WeatherForecast>()
                for index in 0...forecastList.count {
                    if forecastList[index].type == .dictionary {
                        let forecastDayJSON = forecastList[index]
                        let forecastDay = WeatherForecast()
                        forecastDay.date = Date(timeIntervalSince1970: forecastDayJSON["dt"].doubleValue)
                        if forecastDayJSON["temp"].type == .dictionary {
                            forecastDay.weatherTemp = forecastDayJSON["temp"]["day"].doubleValue
                        }
                        if forecastDayJSON["weather"][0].type == .dictionary {
                            let weather = forecastDayJSON["weather"][0]
                            forecastDay.weatherDescription = weather["description"].stringValue
                            forecastDay.imageName = weather["icon"].stringValue
                        }
                        forecasts.append(forecastDay)
                    }
                }
                return forecasts
            }
        }
        print(json)
        return nil
    }
    
}
