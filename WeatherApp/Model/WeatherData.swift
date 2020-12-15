//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Matt Dolidze on 15.12.20.
//

import Foundation

struct WeatherData: Decodable
{
    var name: String
    var main: Main
    var weather : [Weather]
}

struct Main : Decodable
{
    var temp: Double
}

struct Weather: Decodable
{
    var description : String
    var id : Int
}
