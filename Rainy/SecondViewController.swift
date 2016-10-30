//
//  SecondViewController.swift
//  Rainy
//
//  Created by Yana Ivanova on 17.10.16.
//  Copyright © 2016 Yana Ivanova. All rights reserved.
//

import UIKit
import BSKeyboardControls

class SecondViewController: UIViewController, BSKeyboardControlsDelegate, UITextFieldDelegate {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
 
    var currentDate  = Date() {
        didSet {
            self.dateTextField.text = defaultStringForDate(date: currentDate)
        }
    }
    
    var loadedWeatherData : Array<WeatherForecast>?
    var keyboardControls: BSKeyboardControls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardControls = BSKeyboardControls(fields: [cityNameTextField, dateTextField])
        self.keyboardControls?.delegate = self
        self.configureDefaultValues()
        hideWeatherContent()
    }

    func configureDefaultValues() {
        self.cityNameTextField.text = Constants.defaultCityNameString
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.backgroundColor = UIColor(red:0.34, green:0.67, blue:0.73, alpha:0.7)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        let minDate = Date()
        let maxDate = Calendar.current.date(byAdding: .day, value: Constants.defaultMaxDayCount, to: minDate)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.date = minDate
        self.currentDate = minDate
        datePicker.addTarget(self, action: #selector(SecondViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.dateTextField.inputView = datePicker
    }
    
    func defaultStringForDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.defaultDateStringFormat
        return dateFormatter.string(from: date)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        self.currentDate = sender.date
        if self.loadedWeatherData != nil {
            updateForecastForSelectedDate()
        }
    }
    
    func updateUI(forecast: WeatherForecast) {
        
        self.weatherDescription.text = forecast.weatherDescription
        self.temperature.text = String(format: "%.1f", forecast.weatherTemp!) + "℃"
        
        let imageURL = URL(string: Constants.urlImageString + forecast.imageName + ".png")
        if let tImageURL = imageURL {
            self.weatherImage.sd_setImage(with: tImageURL)
        } else {
            self.weatherImage.image = nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        self.timestamp.text = formatter.string(from: forecast.date)
        showWeatherContent()
    }
    
    func updateForecastForSelectedDate() {
        let sortedForecasts = self.loadedWeatherData?.sorted(by: { (frcsts1 : WeatherForecast, frcsts2: WeatherForecast) -> Bool in
            let interval1 = abs(frcsts1.date.timeIntervalSince(self.currentDate))
            let interval2 = abs(frcsts2.date.timeIntervalSince(self.currentDate))
            return interval1 < interval2
        })
        //обновляем UI для ближайшего к выбранной дате прогноза
        if let tForecast = sortedForecasts?.first {
            self.updateUI(forecast: tForecast)
        } else {
            hideWeatherContent()
        }
    }
    
    //получить данные погоды
    func getForecast() {
        var cityName = Constants.defaultCityNameString
        if let text = self.cityNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
            cityName = text
        } else {
            self.cityNameTextField.text = cityName
        }
        if !cityName.isEmpty {
            NetworkCore.sharedInstance.requestDailyForecastByCityName(cityName: cityName) { (forecasts: Array<WeatherForecast>?, error :NetworkCoreError?) in
                self.loadedWeatherData = forecasts
                self.updateForecastForSelectedDate()
            }
        }
    }
    
    @IBAction func searchForecast(_ sender: Any) {
        if self.loadedWeatherData != nil {
            updateForecastForSelectedDate()
        } else {
            hideWeatherContent()
            getForecast()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardControls?.activeField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cityNameTextField {
            self.loadedWeatherData = nil
            hideWeatherContent()
        }
        return true
    }
    
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls!) {
        keyboardControls.activeField.resignFirstResponder()
    }
    
    func hideWeatherContent() {
        self.weatherImage.isHidden = true
        self.temperature.isHidden = true
        self.timestamp.isHidden = true
        self.weatherDescription.isHidden = true
    }
    
    func showWeatherContent() {
        self.weatherImage.isHidden = false
        self.temperature.isHidden = false
        self.timestamp.isHidden = false
        self.weatherDescription.isHidden = false
    }
}

