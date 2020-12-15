//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Matt Dolidze on 15.12.20.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        locationManager.requestWhenInUseAuthorization()
        weatherManager.delegate = self
        
        textfield.delegate = self
        locationManager.delegate = self
        
    }
    @IBAction func onLocationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityname = textField.text
        {
            weatherManager.fetchWeather(cityName: cityname)
        }
        
        
        textfield.text = ""
        textField.placeholder = "Search"
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textfield.text != ""
        {
            textfield.endEditing(true)
            return true
        }
        textField.placeholder = "Please enter a city name"
        return false
    }
}

//MARK: - WeatherDelegate

extension WeatherViewController: WeatherDelegate
{
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }

    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
