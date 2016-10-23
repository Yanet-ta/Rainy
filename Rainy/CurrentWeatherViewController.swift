//
//  CurrentWeatherViewController.swift
//  Rainy
//
//  Created by Yana Ivanova on 17.10.16.
//  Copyright © 2016 Yana Ivanova. All rights reserved.
//

import UIKit
import SDWebImage

class CurrentWeatherViewController: UIViewController{
    
    var currentForecast: WeatherForecast?
    let cityName = "Saint Petersburg"
    
    
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Weather"
        getCurrentForecast()
    }

    func updateUI(forecast: WeatherForecast) {
        print(forecast)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        self.currentCityName.text = forecast.currentCityName.capitalized
        self.weatherDescription.text = forecast.weatherDescription
        self.currentTemp.text = String(format: "%.1f", forecast.currentWeatherTemp!) + "℃"
        
        let imageURL = URL(string: "http://openweathermap.org/img/w/" + forecast.imageName + ".png")
        if let tImageURL = imageURL {
             self.weatherImage.sd_setImage(with: tImageURL)
        } else {
            self.weatherImage.image = nil
        }
        self.timestamp.text = formatter.string(from: Date(timeIntervalSince1970: forecast.timestamp))
        self.humidity.text = "humidity: " + String(format: "%.1f", forecast.humidity) + "%"
        self.windSpeed.text = "wind speed: " + String(format: "%.1f", forecast.windSpeed) + " m/s"
    }
    
    //получить данные погоды
    func getCurrentForecast() {
        NetworkCore.sharedInstance.requestForecastByCityName(cityName: cityName) { (forecast: WeatherForecast?, error :NetworkCoreError?) in
            if let tForecast = forecast {
                self.updateUI(forecast: tForecast)
            }
        }
    }
    
    //обновить данные погоды
    @IBAction func updateCurrentForecast(_ sender: AnyObject) {
        getCurrentForecast()
    }

   
}



    


