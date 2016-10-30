//
//  CurrentWeatherViewController.swift
//  Rainy
//
//  Created by Yana Ivanova on 17.10.16.
//  Copyright © 2016 Yana Ivanova. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation
import INTULocationManager

class CurrentWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentForecast: WeatherForecast?
   // var locationManager: CLLocationManager?
    
    
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var preloaderView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Weather"
        
        showPreloader()
        updateCurrentCoordsAndRequestData()
    }

    func updateUI(forecast: WeatherForecast) {
        print(forecast)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        self.currentCityName.text = forecast.currentCityName.capitalized
        self.weatherDescription.text = forecast.weatherDescription
        self.currentTemp.text = String(format: "%.1f", forecast.weatherTemp!) + "℃"
        
        let imageURL = URL(string: Constants.urlImageString + forecast.imageName + ".png")
        if let tImageURL = imageURL {
             self.weatherImage.sd_setImage(with: tImageURL)
        } else {
            self.weatherImage.image = nil
        }
        self.timestamp.text = formatter.string(from: forecast.date)
        self.humidity.text = "humidity: " + String(format: "%.1f", forecast.humidity) + "%"
        self.windSpeed.text = "wind speed: " + String(format: "%.1f", forecast.windSpeed) + " m/s"
    }
    
    //обновить текущие координаты и запросить данные погоды
    func updateCurrentCoordsAndRequestData() {
        INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 3, block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
            self.updateCurrentForecast(location: currentLocation)
        })
    }
    
    //получить данные погоды
    func updateCurrentForecast(location: CLLocation?) {
        var safeLocation : CLLocation
        if let tLocation = location {
            safeLocation = tLocation
        } else {
            safeLocation = CLLocation(latitude: 59.9389423, longitude: 30.3091397)//по умолчанию для СПб
        }
        NetworkCore.sharedInstance.requestForecastByLocation(latitude: safeLocation.coordinate.latitude, longitude:  safeLocation.coordinate.longitude) { (forecast: WeatherForecast?, error :NetworkCoreError?) in
            if error != nil {
                self.showPreloaderWithError()
            } else {
                if let tForecast = forecast {
                    self.updateUI(forecast: tForecast)
                    self.hidePreloader()
                } else {
                    self.showPreloaderWithError()
                }
            }
        }
    }
    
    func showPreloader() {
        preloaderView.isHidden = false
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    func hidePreloader() {
        preloaderView.isHidden = true
        activityIndicator.stopAnimating()
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    func showPreloaderWithError() {
        preloaderView.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }
    
    
    @IBAction func didTapRetryButton(_ sender: Any) {
        showPreloader()
        updateCurrentCoordsAndRequestData()
    }
    
    @IBAction func didTapUpdateForecastButton(_ sender: AnyObject?) {
        updateCurrentCoordsAndRequestData()
    }

}



    


