//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Matt Dolidze on 15.12.20.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager
{
    var delegate : WeatherDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=893f82ff52c071646ba64d7afeffa50b"
    
    func fetchWeather(cityName: String)
    {
        let url = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: url)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default);
            
            let task = session.dataTask(with: url, completionHandler: handleCompletion(data:response:error:))
            
            task.resume()
        }
    }
    
    func handleCompletion(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil
        {
            delegate?.didFailWithError(error: error!)
            return
        }
        
        if let safeData = data
        {
            if let weather = parseJSON(weatherData: safeData)
            {
                self.delegate?.didUpdateWeather(weather: weather)
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}
